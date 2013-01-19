From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH 1/3] lib/ext2fs: Add ext2fs_symlink
Date: Fri, 18 Jan 2013 21:29:17 -0800
Message-ID: <50FA2F2D.8010901@infradead.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org> <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org> <20130115194330.GF17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48495 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3ASF3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Jan 2013 00:29:19 -0500
In-Reply-To: <20130115194330.GF17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/15/2013 11:43 AM, Theodore Ts'o wrote:
> I'll fix up the this patch before I commit it, but this is a perfect
> exhibit about why I request that code submissions come with test
> cases.  It turns out that there were a couple of problems with
> ext2fs_symlink(), that showed up very quickly as soon as I started
> writing a test case (where it's important to run e2fsck on the
> resulting file system after creating the symlinks --- e2fsck is a
> wonderful rep invariant checkers for ext[234] file systems. :-)
> 
> *) i_blocks must be set to 0 for fast symlinks
> *) The last argument of ext2fs_inode_alloc_stats() indicates whether
>    the new inode is a directory or not.  So when you cut and pasted
>    the code from ext2fs_mkdir(), it needed to be changed.
> *) Zeroing the entire block before setting the symlink in the case
>    where it needs to use an external data block makes it a lot
>    easier to write the regression test.
> 
> So here's the patch I needed to apply on top of your submission....
> 

Ted,

I apologize for not getting to the test case, I meant to, and was still
meaning to. I was pulled away on a number of other tasks, took a family
vacation etc. I figured I was the only one that cared and it would be me
who had to pay the price if things changed while I delayed.

THANK YOU, THANK YOU! I really appreciate you writing the test cases and
fixing up the remaining issues with the patch.

This should now allow us to work with a debugfs script to validate this
tooling to populate filesystem images. Once we have done that, we'll
want to look at pushing some things (like file copy wrappers) from
debugfs into libext2fs and implement the -i (initial dir) option we
discused for mke2fs.

We'll do our validation and then resurface here.

Thanks again!

--
Darren
