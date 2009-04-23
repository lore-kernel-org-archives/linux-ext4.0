From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH]mke2fs: don't check mount flags for regular files
Date: Wed, 22 Apr 2009 22:27:11 -0400
Message-ID: <20090423022711.GA15541@mit.edu>
References: <1237883493-30521-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54467 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbZDWC1P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 22:27:15 -0400
Content-Disposition: inline
In-Reply-To: <1237883493-30521-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 24, 2009 at 04:31:33PM +0800, Peng Tao wrote:
> mke2fs scans /proc/mounts for mount flags of a device. But for regular files,
> this is unnecessary and may cause troubles.
> 
> This can be triggered by:
> $dd if=/dev/null of=rootfs bs=1024 seek=100000 count=0
> $mke2fs -t ext3 -F rootfs
> mke2fs 1.41.4 (27-Jan-2009)
> rootfs is mounted; will not make a filesystem here!

Actually, this is quite necessary; regular files can be mounted using
the loop device, and we want to catch this case.  So simply patching
out the check for regular files is the wrong thing to do, and hides
the real problem.

The correct patch to solve the problem you've reported is attached,
and has been checked into e2fsprogs source repository.

						- Ted

commit f9110f4480eade2d849c4cc08efa49bf0f7f5148
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Apr 22 22:20:22 2009 -0400

    libext2fs: Skip relative pathnames in /etc/mtab in ismounted.c
    
    The functions which test to see if a device is mounted can get
    confused by entries in /etc/mtab for virtual filesystems:
    
    rootfs / rootfs rw 0 0
    none /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
    
    If the device name doesn't start with a slash, ignore the /etc/mtab
    entry, so that relative pathnames passed into functions such as
    ext2fs_check_mount_point() or ext2fs_check_if_mounted() don't return
    false positives.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index 4a7c8c6..4c5500f 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -65,6 +65,8 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 		}
 	}
 	while ((mnt = getmntent (f)) != NULL) {
+		if (mnt->mnt_fsname[0] != '/')
+			continue;
 		if (strcmp(file, mnt->mnt_fsname) == 0)
 			break;
 		if (stat(mnt->mnt_fsname, &st_buf) == 0) {
