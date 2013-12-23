From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Mon, 23 Dec 2013 11:05:28 -0800
Message-ID: <1387825528.5088.59.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab3LWTFa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 14:05:30 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2013-12-23 at 07:09 -0500, Robert Yang wrote:
> Hi Ted,
> 
> I'm very sorry for the late response, I've fixed the problems which you 
> pointed out in the RFC patches, and now the "make check" works well.
> 
> * Changes from the RFC patches:
>   - Move the common code of debugfs and mke2fs to misc/create_inode.c to
>     avoid bloating the tune2fs binary

Hi Robert,

Can you include a size report before and after the changes. With the
concern over code size, we should document the impact.

--
Darren

>   - Fix the error of "make check"
>   - Rebase to the up to date master branch
> 
> Merry Christmas and Happy New Year!
> 
> // Robert
> 
> Robert Yang (10):
>   mke2fs.c: add an option: -d root-directory
>   misc/create_inode.c: copy files recursively
>   misc/create_inode.c: create special file
>   misc/create_inode.c: create symlink
>   misc/create_inode.c: copy regular file
>   misc/create_inode.c: create directory
>   misc/create_inode.c: set owner/mode/time for the inode
>   misc/create_inode.c: handle hardlinks
>   debugfs: use the functions in misc/create_inode.c
>   mke2fs.8.in: update the manual for the -d option
> 
>  debugfs/Makefile.in |   17 +-
>  debugfs/debugfs.c   |  305 ++-------------------------
>  debugfs/debugfs.h   |    1 +
>  misc/Makefile.in    |   13 +-
>  misc/create_inode.c |  575 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  misc/create_inode.h |   35 ++++
>  misc/mke2fs.8.in    |    7 +
>  misc/mke2fs.c       |   43 +++-
>  8 files changed, 691 insertions(+), 305 deletions(-)
>  create mode 100644 misc/create_inode.c
>  create mode 100644 misc/create_inode.h
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


