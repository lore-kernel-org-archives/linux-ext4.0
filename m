From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: reserving code points for new ext4 quota feature
Date: Mon, 14 Feb 2011 22:21:49 -0700
Message-ID: <BD2A37BD-B970-4520-A8AB-589249C96755@dilger.ca>
References: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27509 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1BOFVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Feb 2011 00:21:51 -0500
In-Reply-To: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-14, at 18:07, Aditya Kali <adityakali@google.com> wrote:
> This patch adds support for detecting the new 'quota' feature in ext4.
> The patch reserves code points for usr and group quota inodes and also
> for the feature flag EXT4_FEATURE_RO_COMPAT_QUOTA.
> 
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index fee3919..74f5a2f 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -52,6 +52,9 @@
> #define EXT2_JOURNAL_INO     8    /* Journal inode */
> #define EXT2_EXCLUDE_INO     9    /* The "exclude" inode, for snapshots */
> 
> +#define EXT4_USR_QUOTA_INO     3    /* User quota inode */
> +#define EXT4_GRP_QUOTA_INO     4    /* Group quota inode */

This is missing the fact that ino 3 and 4 are already reserved for ACLs:

#define EXT2_ACL_IDX_INO         3      /* ACL inode */
#define EXT2_ACL_DATA_INO        4      /* ACL inode */

That said, I don't know if those inodes are actually ever used, because the ACLs are stored in xattrs on each inode.

In any case, the quota definitions should replace the ACL ones instead of being hidden after the main list (which is otherwise kept in numeric order). 

Cheers, Andreas





