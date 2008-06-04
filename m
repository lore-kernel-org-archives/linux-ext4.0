From: Jan Kara <jack@suse.cz>
Subject: Re: Ordered mode rewrite for jbd2/ext4
Date: Wed, 4 Jun 2008 18:52:04 +0200
Message-ID: <20080604165204.GA5228@atrey.karlin.mff.cuni.cz>
References: <20080604154435.GE16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43278 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYFDQwF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 12:52:05 -0400
Content-Disposition: inline
In-Reply-To: <20080604154435.GE16572@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  Sorry for replying to myself but I remembered one more thing :)

>   So I've split and ported ordered mode rewrite for ext4+jbd2.
> The core of the rewrite are two patches
> 
> jbd2-Implement-data-ordered-mode-handling-via-inode.patch
> ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
> 
> They also need two trivial fixes:
> vfs-export-filemap_fdatawrite_range.patch
> ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
> 
> And finally there's a patch removing old ordered mode from jbd2:
> jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch
> 
> I've created the patches to be added to the ext4 patch queue just
> after inversion of page lock and transaction start.
> 
> I have refreshed the following patches in the ext4 queue to apply cleanly
> and also fixed some typos in them and added one BUG_ON():
  I've fixed one more problem - during umount, we were calling
ext4_da_writepages() which starts a transaction and lockdep complains
(because superblock lock ranks below transaction start). Because during
this time, we can be actually called only for special inodes (like
journal inode) from iput() we don't really need to start a transaction.
So I've added check into ext4_da_writepages() to bail out if mapping has
no pages (hmm, maybe adding there a check for mapping_tagged(mapping,
PAGECACHE_TAG_DIRTY) would be even better than what I've added).

> ext4-delalloc-sync-hang-with-journal-lock-inverse-fix.patch
> ext4-delalloc-inverse-jbd-and-page-lock-ordering.patch
> ext4-inverse-jbd-and-page-locking-order.patch
> 
> Finally, I've rewritten checks in writepage so
> ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
> should be replaced with
> ext4-add-checks-to-writepage
> 
> as we spoke about it with Aneesh.
> 
> All the patches are attached and I'll also post the new ones separately for
> more convenient review. The tests for 4k blocksize run fine for me. The
> kernel oopses for 1k blocksize because of a problem in ext4_page_mkwrite()
> - I'll post that in a separate mail. If noone objects, patches can be added
> to ext4 patch queue.

									Honza
