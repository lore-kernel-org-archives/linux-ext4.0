From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH V4 00/11] 2fsprogs/mke2fs: add an option: -d
 root-directory
Date: Thu, 06 Mar 2014 00:21:54 -0800
Message-ID: <CF3D6C67.74AD8%dvhart@linux.intel.com>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Robert Yang <liezhi.yang@windriver.com>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaCFI0W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 03:26:22 -0500
In-Reply-To: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/1/14, 0:06, "Robert Yang" <liezhi.yang@windriver.com> wrote:

>* Changes of V4:
>  - Rebase to the up to date master branch
>  - Fix the skip of socket file (break -> continue)

Robert,

Thanks for taking the time to rebase these again. I don't have anything to
add to my existing Reviewed-by's. We'd love to see this merged as we're
currently having to work around issues with gen2extfs in the Yocto Project
and we'd prefer to use upstream e2fsprogs/mke2fs. I think Robert has
addressed all the issues that have been raised.

Are there any additional concerns?

Thanks everyone for your time in reviewing,

Darren

>
>* Changes of V3:
>  - __FUNCTION__ -> __func__
>  - Rebase to the up to date master branch
>
>* Changes of V2:
>  - Add the "-d" option when the code is ready rather than add it in the
>    first commit.
>  - Remove "name = name"
>  - func_name -> __FUNCTION__
>  - The size impact on mke2fs:
>    a) Not stripped:
>       1,837,440 -> 1,903,522 (64K increased)
>    b) Stripped:
>       329,464 -> 321,272 (8K increased)
>    No impact on tune2fs
>
>* Changes from the RFC patches:
>  - Move the common code of debugfs and mke2fs to misc/create_inode.c to
>    avoid bloating the tune2fs binary
>  - Fix the error of "make check"
>  - Rebase to the up to date master branch
>
>// Robert
>
>Robert Yang (11):
>  mke2fs: add the ability to copy files from a given directory
>  misc/create_inode.c: copy files recursively
>  misc/create_inode.c: create special file
>  misc/create_inode.c: create symlink
>  misc/create_inode.c: copy regular file
>  misc/create_inode.c: create directory
>  misc/create_inode.c: set owner/mode/time for the inode
>  mke2fs.c: add an option: -d root-directory
>  misc/create_inode.c: handle hardlinks
>  debugfs: use the functions in misc/create_inode.c
>  mke2fs.8.in: update the manual for the -d option
>
> debugfs/Makefile.in |   17 +-
> debugfs/debugfs.c   |  305 ++-------------------------
> debugfs/debugfs.h   |    1 +
> misc/Makefile.in    |   13 +-
> misc/create_inode.c |  574
>+++++++++++++++++++++++++++++++++++++++++++++++++++
> misc/create_inode.h |   35 ++++
> misc/mke2fs.8.in    |    7 +
> misc/mke2fs.c       |   43 +++-
> 8 files changed, 690 insertions(+), 305 deletions(-)
> create mode 100644 misc/create_inode.c
> create mode 100644 misc/create_inode.h
>
>-- 
>1.7.10.4
>
>


-- 
Darren Hart
Yocto Project - Linux Kernel
Intel Open Source Technology Center




