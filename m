From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [REGRESSION] xfstests #269 without journal failure against 'dev'
 branch
Date: Thu, 21 Feb 2013 14:44:48 -0500
Message-ID: <20130221194448.GB17322@thunk.org>
References: <20130217170918.GA4059@gmail.com>
 <20130218045747.GC10361@thunk.org>
 <20130218172140.GA3056@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49314 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab3BUTow (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 14:44:52 -0500
Content-Disposition: inline
In-Reply-To: <20130218172140.GA3056@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was able to reproduce the failure reliably by using a 5G tmpfs file
for the VM's disk file, and bisected this down to:

    ext4: support simple conversion of extent-mapped inodes to use i_blocks
    
    In order to make it simpler to test the code which support
    i_blocks/indirect-mapped inodes, support the conversion of inodes
    which are less than 12 blocks and which are contained in no more than
    a single extent.
    
    The primary intended use of this code is to converting freshly created
    zero-length files and empty directories.
    
    Note that the version of chattr in e2fsprogs 1.42.7 and earlier has a
    check that prevents the clearing of the extent flag.  A simple patch
    which allows "chattr -e <file>" to work will be checked into the
    e2fsprogs git repository.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I don't think this is actually causing the problem, but rather
exposing a latent bug in fs/ext4/indirect.c.  From some code
inspection that I did investigating the resize2fs bug, it's pretty
clear that indirect.c codepath has some bugs dealing with ENOSPC
conditions when allocating indirect metadata blocks.

Xfstests #269 runs fsstress in parallel with ENOSPC hitters, and one
of the things fsstress does is to call the FS_IOC_SETFLAGS with random
values, so with this commit, we are migrating some small files to use
indirect block..  I suspect that when we then do some writes to these
small files and they hit an ENOSPC condition, it causes the file
system corruption.

I patched ext4_ind_migrate() to log an ext4_warning and then return
-ENOSPC, and confirmed that (a) with ext4_end_migrate() disabled, the
fs corruption problem went away, and (b) fsstress is calling
FS_IOC_SETFLAGS with completely random values, and thus causing us to
migrate some of the extent-mapped files to indirect block mapped
files.

Given that extents->indirect migration isn't really that important, I
propose we deal with this by dropping the above commit for now.  It's
clear we need to fix up fs/ext4/indirect.c, especially as more
distro's consider using ext4 to support ext3 file systems.  So after
we fix the ENOSPC bugs I've noticed in ext4_alloc_branch(), we can try
introducing the extent->indirect migration feature again for the next
merge window.

Zheng, thanks for calling this bug to our attention, and thanks for
your extensive testing efforts!

       	      	  	       	      - Ted

