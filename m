From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug in ext2fs_set_gdt_csum() and uninit_groups handling
Date: Thu, 3 Apr 2008 10:17:45 -0400
Message-ID: <20080403141745.GB13486@mit.edu>
References: <E1JhOy1-0006g8-Oy@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54913 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756821AbYDCORy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 10:17:54 -0400
Content-Disposition: inline
In-Reply-To: <E1JhOy1-0006g8-Oy@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So after looking at this some more, I think I understand what had
happened.  The code as currently written is OK, because we are
initializing the inode table even if the uninit_group feature is
enabled.  There is a new COMPAT feature, lazy_bg, which causes mke2fs
to skip initializing the inode table --- but since it's not in the
allowed set of filesystem features, we're not in any danger since
currently zeroing of the inode table can't be skipped.

HOWEVER, the code in ext2fs_set_gdt_csum() which I pointed out in my
earlier message is a ticking time bomb that will go off if we ever
enable lazy_bg.

Given that uninit_groups has only recently hit the e2fsprosg mainline,
and as far as I know, no one is currently using it in production ---
and those that might be, such as CFS, are zero'ing out the entire
inode table anyway (since the feature was originally called gdt_cksum)
--- and it would seem HIGHLY uninituitive that uninit_groups, or
uninit_bg doesn't actually prevent the slow step of zeroing the inode
table, I propose that we do the following:

*)  Remove lazy_bg feature flag entirely

*)  Remove the bogus code in ext2fs_set_gdt_csum()

*)  Change mke2fs to skip initializing the inode tables if
    uninit_groups is set.

*)  Implement the kernel code for ext4 so it will zero out the inode
    table in the background.

Does this make sense?  I believe it is safe, given that all existing
filesystems using uninit_groups (what few of them exist) have the
inode table completely zero'ed out, so there is no danger in making
this change in the deifnition of what uninit_groups (or uninit_bg) means.

     	       	   	      	      		    - Ted
