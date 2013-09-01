From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Sun, 1 Sep 2013 11:26:54 +0800
Message-ID: <20130901032654.GA21899@gmail.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dvhart@linux.intel.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:65356 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3IADZ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Aug 2013 23:25:57 -0400
Received: by mail-pa0-f53.google.com with SMTP id lb1so3842508pab.26
        for <linux-ext4@vger.kernel.org>; Sat, 31 Aug 2013 20:25:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Robert,

On Wed, Aug 28, 2013 at 01:25:50PM +0800, Robert Yang wrote:
> This option is used for adding the files from the root-directory to the
> filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
> support ext4.
> 
> * Questions
>   - Is such an option acceptable ?
> 
>   - Most of the code have been in debugfs/debugfs.c already, I moved them to
>     misc/util.c and modified them to let both mke2fs and debugfs can use them,
>     maybe we should put these code in another separate file ?
> 
>   - Where can I get the up-to-date development git repo, please? I think that
>     there would be conflicts with the dev git repo, I'd like to rebase it if I
>     can get the repo, currently, I'm using this one:
> 
>     http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git
> 
> * The size impact on misc/mke2fs:
>    1,677,297 -> 1,728,110 (non stripped, about 50K increases)
>    316,968 -> 325,160 (stripped, 8K increases)
> 
> Please feel free to give your comments.

If I understand correctly, after applied this patch set, we can copy
some files from a directory that is indicated by '-d' option when we
create a new ext4 file system.  My concern is why we need to add this
option?  Without this option I can use 'mkfs.ext4 ${DEV}', 'mount ${DEV}
${MNT}' and 'cp ${SRC} ${MNT}' to do the same thing.  I am not
convinced.  Could you please describe more details for this patch set?

Regards,
                                                - Zheng

> 
> // Robert
> 
> Robert Yang (10):
>   mke2fs.c: add an option: -d root-directory
>   misc/util.c: implement populate_fs()
>   misc/util.c: create special file
>   misc/util.c: create symlink
>   misc/util.c: copy regular file
>   misc/util.c: create directory
>   misc/util.c: set more information for inode
>   misc/util.c: handle hardlinks
>   mke2fs.8.in: update the manual for the -d option
>   debugfs: use the functions in misc/util.c
> 
>  debugfs/Makefile.in |   7 +-
>  debugfs/debugfs.c   | 251 ++-----------------------
>  debugfs/debugfs.h   |   1 +
>  misc/mke2fs.8.in    |   7 +
>  misc/mke2fs.c       |  39 +++-
>  misc/util.c         | 519 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  misc/util.h         |  32 ++++
>  7 files changed, 614 insertions(+), 242 deletions(-)
> 
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
