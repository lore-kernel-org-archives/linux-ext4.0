From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 08/19] ext4: replace inode uid,gid,mode init with helper v2
Date: Thu, 18 Feb 2010 10:09:13 +0300
Message-ID: <87k4ub9g12.fsf_-_@openvz.org>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
	<1266432013-9241-3-git-send-email-dmonakhov@openvz.org>
	<E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:27297 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0BRHJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Feb 2010 02:09:17 -0500
In-Reply-To: <E5AA2C0B-42FA-4025-A155-7ACD02EDE261@sun.com> (Andreas Dilger's
	message of "Wed, 17 Feb 2010 16:39:54 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Andreas Dilger <adilger@sun.com> writes:

> On 2010-02-17, at 11:40, Dmitry Monakhov wrote:
>> @@ -985,16 +985,12 @@ got:
>> 		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
>> 	}
>>
>> +	if (test_opt (sb, GRPID)) {
>
> (style) please don't add the space after "test_opt" back into the code.
Ok, updated, new version attached.
>
>
>> +		inode->i_mode = mode;
>> +		inode->i_uid = current_fsuid();
>> 		inode->i_gid = dir->i_gid;
>> 	} else
>> +		inode_init_owner(inode, dir, mode);
>
>
> This code is a bit misleading, since it implies that "i_uid" and
> "i_mode" are set this way due to the GRPID option, even though with
> further investigation it is just set the same way in both cases.
>
> Ted,
> what do you think of just removing the "GRPID" mount option?  I
> believe this was around for ages, due to the lack of BSD setgid-on- 
> parent functionality in Linux.  I don't think it is needed anymore,
> since the BSD functionality is much more flexible (it can be set on a
> per-directory basis instead of for the whole filesystem).
>
> I suppose one way to find out positively would be to add a printk() to
> case Opt_grpid: in the option parsing that this option is deprecated,
> and to contact linux-ext4@vger.kernel.org if you are still using it.
Let's post this as separate patch because this change existing behavior.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

--=-=-=
Content-Disposition: inline;
 filename=0008-ext4-replace-inode-uid-gid-mode-init-with-helper-v2.patch

>From a1336d4e57352423a7eb0f7b95ed20e78dcefc8c Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 18 Feb 2010 09:44:01 +0300
Subject: [PATCH 08/19] ext4: replace inode uid,gid,mode init with helper v2


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ialloc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f3624ea..a2a35d3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -985,16 +985,12 @@ got:
 		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
 	}
 
-	inode->i_uid = current_fsuid();
-	if (test_opt(sb, GRPID))
+	if (test_opt(sb, GRPID)) {
+		inode->i_mode = mode;
+		inode->i_uid = current_fsuid();
 		inode->i_gid = dir->i_gid;
-	else if (dir->i_mode & S_ISGID) {
-		inode->i_gid = dir->i_gid;
-		if (S_ISDIR(mode))
-			mode |= S_ISGID;
 	} else
-		inode->i_gid = current_fsgid();
-	inode->i_mode = mode;
+		inode_init_owner(inode, dir, mode);
 
 	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
 	/* This is the optimal IO size (for stat), not the fs block size */
-- 
1.6.6


--=-=-=--
