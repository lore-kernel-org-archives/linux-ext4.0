From: Patrick Dung <mpatdung@gmail.com>
Subject: Do you know about this ext4 file system corruption in RHEL 7.3?
 (block bitmap and and bg descriptor mismatch)
Date: Thu, 16 Feb 2017 01:54:08 +0800
Message-ID: <CAEtPA0DhZpvFWWiyDBRCjFD3T+WGheTKLyWOZ+UftnmvYuT0qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35820 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752405AbdBORyJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Feb 2017 12:54:09 -0500
Received: by mail-it0-f46.google.com with SMTP id 203so71159204ith.0
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 09:54:09 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I had a RHEL 7.3 vmware workstaion VM (host is Linux running Fedora).
The VM used LSI SAS adapter. I had previously used it for a few weeks
without problem.

When I reboot it in yesterday, there is file system corruption (check
the end of the log):

Feb 15 04:37:48 server02 systemd-fsck: /dev/sda1: clean, 336/128016
files, 169035/512000 blocks
Feb 15 04:37:48 server02 systemd: Reached target Swap.
Feb 15 04:37:48 server02 systemd: Starting Swap.
Feb 15 04:37:48 server02 systemd: Started File System Check on
/dev/disk/by-uuid/f31387b8-b3b8-4da8-983e-28a0c82145ea.
Feb 15 04:37:48 server02 systemd-fsck: mount1: clean, 4392/196608
files, 116093/786432 blocks
Feb 15 04:37:48 server02 systemd: Started File System Check on
/dev/disk/by-label/mount1-disk.
Feb 15 04:37:48 server02 systemd: Mounting /mount1...
Feb 15 04:37:48 server02 systemd: Mounting /boot...
Feb 15 04:37:48 server02 kernel: EXT4-fs (sdc): mounted filesystem
with ordered data mode. Opts: journal_checksum,nodelalloc
Feb 15 04:37:48 server02 systemd: Mounted /mount1.
Feb 15 04:37:48 server02 kernel: EXT4-fs (sda1): mounted filesystem
with ordered data mode. Opts: (null)
Feb 15 04:37:48 server02 systemd: Mounted /boot.
Feb 15 04:37:50 server02 kernel: floppy0: no floppy controllers found
Feb 15 04:37:50 server02 systemd: Started udev Wait for Complete
Device Initialization.
Feb 15 04:37:50 server02 systemd: Starting Activation of DM RAID sets...
Feb 15 04:37:50 server02 systemd: Started Activation of DM RAID sets.
Feb 15 04:37:50 server02 systemd: Reached target Local File Systems.
Feb 15 04:37:50 server02 systemd: Starting Local File Systems.
Feb 15 04:37:50 server02 systemd: Starting Tell Plymouth To Write Out
Runtime Data...
Feb 15 04:37:50 server02 systemd: Starting Preprocess NFS configuration...
Feb 15 04:37:50 server02 systemd: Starting Import network
configuration from initramfs...
Feb 15 04:37:50 server02 systemd: Reached target Encrypted Volumes.
Feb 15 04:37:50 server02 systemd: Starting Encrypted Volumes.
Feb 15 04:37:50 server02 systemd: Started Tell Plymouth To Write Out
Runtime Data.
Feb 15 04:37:50 server02 systemd: Started Preprocess NFS configuration.
Feb 15 04:37:50 server02 systemd: Started Import network configuration
from initramfs.
Feb 15 04:37:50 server02 systemd: Starting Create Volatile Files and
Directories...
Feb 15 04:37:50 server02 systemd: Started Create Volatile Files and Directories.
Feb 15 04:37:50 server02 systemd: Starting Security Auditing Service...
Feb 15 04:37:51 server02 augenrules: /sbin/augenrules: No change
Feb 15 04:37:51 server02 systemd: Started Security Auditing Service.
Feb 15 04:37:51 server02 systemd: Starting Update UTMP about System
Boot/Shutdown...
Feb 15 04:37:51 server02 auditd[921]: Started dispatcher: /sbin/audispd pid: 937
Feb 15 04:37:51 server02 kernel: type=1305 audit(1487104671.281:3):
audit_pid=921 old=0 auid=4294967295 ses=4294967295
subj=system_u:system_r:auditd_t:s0 res=1
Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1448: group 38, block 1249221:freeing already freed
block (bit 4037); block bitmap corrupt.
Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy:757: group 38, block bitmap and bg descriptor
inconsistent: 14676 vs 14677 free clusters
Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
mb_free_blocks:1448: group 33, block 1086784:freeing already freed
block (bit 5440); block bitmap corrupt.
Feb 15 04:37:51 server02 kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy:757: group 33,
Feb 15 04:37:51 server02 kernel: block bitmap and bg descriptor
inconsistent: 4823 vs 4845 free clusters

After checking Redhat KB, it seems only RHEL 5 and RHEL 6 are affected.
https://access.redhat.com/solutions/155873

I had already performed file system repair on the two corrupted file
sytems (root and another mount point)
Since lots of files were corrupted (inside lost+found), the system is
not usable, I had restored the VM from backup.
So I do not have the corrupted file system now.

The kernel version is stock RHEL 7.3 kernel-3.10.0-514.el7.
On the root file system, I had manually enabled journal_checksum.
On another file system, I had manually enable journal_checksum and nodelalloc.

Thanks and best regards,
Patrick
