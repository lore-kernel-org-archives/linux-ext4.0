From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC] e2fsprogs/mke2fs: add an option  "-d root-directory"
Date: Mon, 05 Aug 2013 08:17:42 -0700
Message-ID: <1375715862.14739.72.camel@dvhart-mobl4.amr.corp.intel.com>
References: <51FF64FF.5090309@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9412 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3HEPSD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 11:18:03 -0400
In-Reply-To: <51FF64FF.5090309@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2013-08-05 at 16:40 +0800, Robert Yang wrote:
> Hello folks,
> 
> I'd like to add an "-d root-directory" option for mke2fs, which is used
> for adding files from the "root-directory" to the filesystem after the
> formatting, it is similar to genext2fs, but which only supports ext2 AFAIK.
> it's usage example would be:
> 
> $ mke2fs -t extX -d <dir> <device>
> 
> I've done a few work on it, we can re-use the code from debugfs/debugfs.c,
> here are the draft implementation thoughts:
> 
> Move a part of the code from debugfs/debugfs.c to misc/util.c, for example,
> we will change the function do_write() in debugfs.c to:
> 
> void do_write(int argc, char *argv[])
> {
> 	[snip];
> 	retval = do_write_internal();
>          [snip];
> }
> 
> The do_write_internal() will be defined in misc/util.c, then both debugfs.c
> and mke2fs.c can use it. We will do the similar thing to do_mkdir(),
> do_symlink() and so on.
> 
> My questions are:
> 1) Is the "-d root-directory" option acceptable ?
> 2) Is the implementation idea OK ?
> 
> Please feel free to give your comments, and I will send the patches later
> if this is fine.

The biggest concern expressed here when we first discussed this was an
increase in size. When you prepare patches, please include a size delta
report of the binary and ensure the dependencies don't increase any more
than absolutely necessary - preferably not at all.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


