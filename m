From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] e2fsprogs: revise and extend chattr(1) and chattr usage()
Date: Thu, 19 Jun 2014 23:27:02 -0600
Message-ID: <5C296395-2A5C-4F90-96ED-5B4FD7EF6E0B@dilger.ca>
References: <53A36F0E.6090105@redhat.com> <53A37129.2040409@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47476 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934263AbaFTF1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2014 01:27:06 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so2571851pdi.23
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2014 22:27:05 -0700 (PDT)
In-Reply-To: <53A37129.2040409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please don't do the "use backtick "`" as opening quote for single quote "'" trick" that the GNU utils just stopped doing. I don't think this improves readability, and it makes syntax highlighting tools unhappy since there are imbalanced quotes. 

Cheers, Andreas

> On Jun 19, 2014, at 17:24, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> The chattr(1) manpage and chattr usage() output were missing some flags.
> 
> Add those, and make some other minor cosmetic fixes.
> 
> (I've left out the 'B' (EXT2_COMPRBLK_FL) flag, because
> it's not actually used anywhere, and I can't figure out
> how it differs from 'c' (EXT2_COMPR_FL))
> 
> Also, because the matrix of filesystems & flags is quite large,
> refer to filesystem-specific manpages for detailed discussion
> of flags supported by those filesystems, rather than trying to
> cover it all in this manpage.  I'll send those manpage
> updates to the appropriate lists a bit later.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index ce426e8..6f64e09 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -47,8 +47,17 @@ but not modified by chattr:
> compression error (E),
> huge file (h),
> indexed directory (I),
> +inline data (N),
> compression raw access (X),
> and compressed dirty file (Z).
> +.PP
> +Not all flags are supported or utilized by all filesystems; refer to
> +filesystem-specific man pages such as
> +.BR btrfs (5), 
> +.BR ext4 (5),
> +and
> +.BR xfs (5)
> +for more filesystem-specific details.
> .SH OPTIONS
> .TP
> .B \-R
> @@ -67,7 +76,7 @@ A file with the `a' attribute set can only be open in append mode for writing.
> Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> capability can set or clear this attribute.
> .PP
> -When a file with the 'A' attribute set is accessed, its atime record is
> +When a file with the `A' attribute set is accessed, its atime record is
> not modified.  This avoids a certain amount of disk I/O for laptop
> systems.
> .PP
> @@ -77,12 +86,12 @@ this file compresses data before storing them on the disk.  Note: please
> make sure to read the bugs and limitations section at the end of this
> document.
> .PP
> -A file with the 'C' attribute set will not be subject to copy-on-write
> +A file with the `C' attribute set will not be subject to copy-on-write
> updates.  This flag is only supported on file systems which perform
> -copy-on-write.  (Note: For btrfs, the 'C' flag should be
> +copy-on-write.  (Note: For btrfs, the `C' flag should be
> set on new or empty files.  If it is set on a file which already has
> data blocks, it is undefined when the blocks assigned to the file will
> -be fully stable.  If the 'C' flag is set on a directory, it will have no
> +be fully stable.  If the `C' flag is set on a directory, it will have no
> effect on the directory, but new files created in that directory will
> the No_COW attribute.)
> .PP
> @@ -94,18 +103,18 @@ When a directory with the `D' attribute set is modified,
> the changes are written synchronously on the disk; this is equivalent to
> the `dirsync' mount option applied to a subset of the files.
> .PP
> -The 'e' attribute indicates that the file is using extents for mapping
> +The `e' attribute indicates that the file is using extents for mapping
> the blocks on disk.  It may not be removed using
> .BR chattr (1).
> .PP
> -The 'E' attribute is used by the experimental compression patches to
> +The `E' attribute is used by the experimental compression patches to
> indicate that a compressed file has a compression error.  It may not be
> set or reset using
> .BR chattr (1),
> although it can be displayed by
> .BR lsattr (1).
> .PP
> -The 'h' attribute indicates the file is storing its blocks in units of the
> +The `h' attribute indicates the file is storing its blocks in units of the
> filesystem blocksize instead of in units of sectors, and means that the file
> is (or at one time was) larger than 2TB.  It may not be set or reset using
> .BR chattr (1),
> @@ -117,7 +126,7 @@ renamed, no link can be created to this file and no data can be written
> to the file.  Only the superuser or a process possessing the
> CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
> .PP
> -The 'I' attribute is used by the htree code to indicate that a directory
> +The `I' attribute is used by the htree code to indicate that a directory
> is being indexed using hashed trees.  It may not be set or reset using
> .BR chattr (1),
> although it can be displayed by
> @@ -131,6 +140,12 @@ is already journalled and this attribute has no effect.  Only
> the superuser or a process possessing the CAP_SYS_RESOURCE
> capability can set or clear this attribute.
> .PP
> +A file with the `N' attribute set indicates that the file has data 
> +stored inline, within the inode itself. It may not be set or reset using
> +.BR chattr (1),
> +although it can be displayed by
> +.BR lsattr (1).
> +.PP
> When a file with the `s' attribute set is deleted, its blocks are zeroed
> and written back to the disk.  Note: please make sure to read the bugs
> and limitations section at the end of this document.
> @@ -139,19 +154,19 @@ When a file with the `S' attribute set is modified,
> the changes are written synchronously on the disk; this is equivalent to
> the `sync' mount option applied to a subset of the files.
> .PP
> -A file with the 't' attribute will not have a partial block fragment at
> +A file with the `t' attribute will not have a partial block fragment at
> the end of the file merged with other files (for those filesystems which
> support tail-merging).  This is necessary for applications such as LILO
> which read the filesystem directly, and which don't understand tail-merged
> files.  Note: As of this writing, the ext2 or ext3 filesystems do not
> (yet, except in very experimental patches) support tail-merging.
> .PP
> -A directory with the 'T' attribute will be deemed to be the top of
> +A directory with the `T' attribute will be deemed to be the top of
> directory hierarchies for the purposes of the Orlov block allocator.
> This is a hint to the block allocator used by ext3 and ext4 that the
> subdirectories under this directory are not related, and thus should be
> spread apart for allocation purposes.   For example it is a very good
> -idea to set the 'T' attribute on the /home directory, so that /home/john
> +idea to set the `T' attribute on the /home directory, so that /home/john
> and /home/mary are placed into separate block groups.  For directories
> where this attribute is not set, the Orlov block allocator will try to
> group subdirectories closer together where possible.
> @@ -161,14 +176,14 @@ saved.  This allows the user to ask for its undeletion.  Note: please
> make sure to read the bugs and limitations section at the end of this
> document.
> .PP
> -The 'X' attribute is used by the experimental compression patches to
> -indicate that a raw contents of a compressed file can be accessed
> +The `X' attribute is used by the experimental compression patches to
> +indicate that the raw contents of a compressed file can be accessed
> directly.  It currently may not be set or reset using
> .BR chattr (1),
> although it can be displayed by
> .BR lsattr (1).
> .PP
> -The 'Z' attribute is used by the experimental compression patches to
> +The `Z' attribute is used by the experimental compression patches to
> indicate a compressed file is dirty.  It may not be set or reset using
> .BR chattr (1),
> although it can be displayed by
> @@ -179,7 +194,7 @@ although it can be displayed by
> was written by Remy Card <Remy.Card@linux.org>.  It is currently being
> maintained by Theodore Ts'o <tytso@alum.mit.edu>.
> .SH BUGS AND LIMITATIONS
> -The `c', 's',  and `u' attributes are not honored
> +The `c', `s',  and `u' attributes are not honored
> by the ext2, ext3, and ext4 filesystems as implemented in the current
> mainline Linux kernels.
> .PP
> @@ -191,4 +206,7 @@ The `D' option is only useful on Linux kernel 2.5.19 and later.
> is part of the e2fsprogs package and is available from
> http://e2fsprogs.sourceforge.net.
> .SH SEE ALSO
> -.BR lsattr (1)
> +.BR lsattr (1),
> +.BR btrfs (5),
> +.BR ext4 (5),
> +.BR xfs (5).
> diff --git a/misc/chattr.c b/misc/chattr.c
> index d5a6a61..f130108 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -83,7 +83,7 @@ static unsigned long sf;
> static void usage(void)
> {
>    fprintf(stderr,
> -        _("Usage: %s [-RVf] [-+=aAcCdDeijsSu] [-v version] files...\n"),
> +        _("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] files...\n"),
>        program_name);
>    exit(1);
> }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
