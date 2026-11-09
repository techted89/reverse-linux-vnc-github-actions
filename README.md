# Reverse Linux VNC for GitHub Actions
Enable VNC access on GitHub Actions VMs for general use

![xd](screenshot.png)

## Usage
1) Create an account on [Tailscale](https://login.tailscale.com/signup), and get your auth key [here](https://login.tailscale.com/admin/keys) (or use the default)

2) Fork this repository

3) Go to the Settings tab of your repository, and go to Secrets, add the following secrets:
```
Name: NGROK_AUTH_TOKEN
Example Value: (obviously you insert the ngrok auth token of your account that you obtained in step 1)

Name: VNC_PASSWORD
Example Value: password
The VNC password that you will be using, if exceeds more than 8 characters, it will be truncated

Name: VNC_DEPTHVALUE
Example Value: 16
This is the default color depth that the VNC will be using, the minimum acceptable value is 8
But i recommend you to set it at 16

Name: VNC_SCREENSIZE
Example Value: 800x600
This will be the screen resolution in your VNC session, i don't know a minimal value but it's up to you anyway.

Name: TAILSCALE_AUTH_KEY
Example Value: tskey-abcdef1234567890abcdef1234567890abcdef1234567890abcdef12345678
A Tailscale auth key for connecting the GitHub Actions runner to your tailnet
```

All of those secrets are required for the script to work, if you forget to add one, then it will throw an error

4) Trigger an build, by editing this README or uploading anything to your repository, don't modify the contents of the resources or scripts folders

5) Go to the Actions tab of your repository, go to your build process and wait until the pre-last step, that it will hang forever while setting ngrok's tunnel

6) **After the build completes, check the output for connection information:**

The workflow will display:
- **Tailscale IP address** - Use this for both SSH and direct VNC connection
- **Ngrok tunnel** - Traditional tunnel method

7) **Choose your connection method:**

### Option A: Tailscale (Recommended - Easiest)
- **VNC via Tailscale:** Connect your VNC client to the Tailscale IP displayed in the workflow output
  - The VNC server will be accessible on the standard VNC port through the Tailscale network
- **SSH via Tailscale:** `ssh runner@<TAILSCALE_IP>` - password is `runner`
  - Tailscale natively provides SSH access on port 22

### Option B: Ngrok (Traditional)
1) Visit ngrok's tunnel list [dashboard](https://dashboard.ngrok.com/status/tunnels)
2) Take note of the active tunnel host and port
3) Connect to the host and port combination with a VNC client of your preference
4) If it requires an username, write "runner" and as password, the password that you wrote in the VNC_PASSWORD secret

### Option C: Direct (if on same network)
- VNC server runs on port 5901
- Connect directly if you have network access

### Please note that the duration of the runners in GitHub Actions is for 6 hours, so, the VNC server lasts 6 hours