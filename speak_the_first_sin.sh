road to eden reference for these istructions: # How to Upload (Commit & Push) SinOps Files to Your GitHub Repository from the Command Line

These instructions assume you have already [created a GitHub repository](https://github.com/djones0405/SinOps.git and have [git installed](https://git-scm.com/downloads) on your system.

---

## 1. Open a Terminal or Command Prompt

- On Windows: Use Git Bash, Command Prompt, or PowerShell.
- On macOS/Linux: Use Terminal.

---

## 2. Navigate to Your SinOps Project Directory

```bash
cd C:\Users\jodaniel\OneDrive - FL Agency for Health Care Administration\AI-share\sinops
```

---

## 3. Initialize Git (If Your Project Is Not Yet a Git Repo)

```bash
git init
```

---

## 4. Add Your Remote Repository

Replace `<your-username>` and `<your-repo>` with your GitHub details:

```bash
git remote add origin https://github.com/djones0405/SinOps.git
```

- If you already added a remote, skip this step.

---

## 5. Add All Files to the Repo

```bash
git add .
```
This will stage all files not excluded by `.gitignore`.

---

## 6. Commit the Files

```bash
git commit -m "Initial upload of SinOps scripts and configuration"
```

---

## 7. Push to GitHub

If this is your first push, use:

```bash
git branch -M main
git push -u origin main
```

For subsequent pushes, use:

```bash
git push
```

---

## 8. Verify

Visit your repository on GitHub to confirm the files have uploaded:  
`https://github.com/djones0405/SinOps.git`

---

## Notes

- **.gitignore:** Your `.gitignore` is set up to exclude backups, logs, and other unneeded files from your repository.
- **Updating:** After making changes, repeat steps 5–7.
- **Authentication:** If prompted, log in with your GitHub credentials or use a [personal access token](https://github.com/settings/tokens).

---

## Troubleshooting

- If you see authentication errors, ensure you are logged in with `git config --global user.name` and `git config --global user.email`.
- For HTTPS issues, consider using SSH ([setup guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)).
- If you need to change the remote, use:  
  ```bash
  git remote set-url origin https://github.com/djones0405/SinOps.git
  ```

---