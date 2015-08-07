From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 12/19] libext2fs: Bump default number of reserved inodes to 64
Date: Fri, 7 Aug 2015 13:11:05 -0600
Message-ID: <257AFF7C-B416-481B-9DB0-5017A8799967@dilger.ca>
References: <1438944689-24562-1-git-send-email-jack@suse.com> <1438944689-24562-13-git-send-email-jack@suse.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36808 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946006AbbHGTLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2015 15:11:08 -0400
Received: by pacrr5 with SMTP id rr5so58478821pac.3
        for <linux-ext4@vger.kernel.org>; Fri, 07 Aug 2015 12:11:08 -0700 (PDT)
In-Reply-To: <1438944689-24562-13-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 7, 2015, at 4:51 AM, Jan Kara <jack@suse.com> wrote:
> 
> From: Jan Kara <jack@suse.cz>
> 
> We ran out of reserved inodes so bump the default number of reserved
> inodes to 64 to get some breathing space. Otherwise we have to do a full
> fs scan when increasing number of reserved inodes when some feature
> needing another reserved inode is enabled. This consumes 13.5 KB on a
> filesystem which is negligible these days.

This patch also needs to fix all of the regression tests that will
fail because the inode numbers are different.  Otherwise "make check"
will fail.

Cheers, Andreas

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> lib/ext2fs/initialize.c | 2 +-
> misc/mke2fs.8.in        | 8 ++++----
> misc/mke2fs.conf.5.in   | 7 ++++---
> 3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 75fbf8ee0061..0ecf4606ce48 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -186,7 +186,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> 
> 	set_field(s_rev_level, EXT2_GOOD_OLD_REV);
> 	if (super->s_rev_level >= EXT2_DYNAMIC_REV) {
> -		set_field(s_first_ino, EXT2_GOOD_OLD_FIRST_INO);
> +		set_field(s_first_ino, 64);
> 		set_field(s_inode_size, EXT2_GOOD_OLD_INODE_SIZE);
> 		if (super->s_inode_size >= sizeof(struct ext2_inode_large)) {
> 			int extra_isize = sizeof(struct ext2_inode_large) -
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 520a07185f9f..6eef1d97bfbf 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -386,10 +386,10 @@ Do not attempt to discard blocks at mkfs time.
> @QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
> .TP
> .BI reserved_inodes= number
> -Specify the number of inodes reserved for system files. This number must be
> -at least 10. Currently 10 is enough but future features may require additional
> -reserved inodes. Reserving more inodes after file system is created requires
> -full file system scan so it can take a long time.
> +Specify the number of inodes reserved for system files. This number must be at
> +least 10, default is 64. Currently 10 is enough but future features may require
> +additional reserved inodes.

I'm not sure it is worthwhile to mention "currently 10 is enough",
since this should be updated every time some new inode is reserved,
but it will likely be forgotten.  I don't think users really care
about this in the end.

> Reserving more inodes after file system is created
> +requires full file system scan so it can take a long time.
> .RE
> .TP
> .BI \-f " fragment-size"
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index 06ca9e4eabc4..b35767bfedf2 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -197,9 +197,10 @@ reserved ratio. This value can be a floating point number.
> .TP
> .I reserved_inodes
> This relation specifies the default number of inodes reserved for system files.
> -The number must be at least 10. Currently 10 is enough but future features may
> -require additional reserved inodes. Reserving more inodes after file system is
> -created requires full file system scan so it can take a long time.
> +The number must be at least 10, default is 64. Currently 10 is enough but
> +future features may require additional reserved inodes. Reserving more inodes
> +after file system is created requires full file system scan so it can take a
> +long time.
> .TP
> .I undo_dir
> This relation specifies the directory where the undo file should be
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





