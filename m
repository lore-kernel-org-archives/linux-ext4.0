From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext3: handle deleting corrupted indirect blocks
Date: Tue, 24 Jun 2008 17:13:36 -0700
Message-ID: <1214352816.27507.341.camel@BVR-FS.beaverton.ibm.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214315240-22950-1-git-send-email-duaneg@dghda.com>
	 <20080624140551.567149b6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, sct@redhat.com,
	adilger@clusterfs.com, sliedes@cc.hut.fi
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:59966 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYFYAM6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 20:12:58 -0400
In-Reply-To: <20080624140551.567149b6.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Tue, 2008-06-24 at 14:05 -0700, Andrew Morton wrote:
> On Tue, 24 Jun 2008 14:47:20 +0100
> "Duane Griffin" <duaneg@dghda.com> wrote:
> 
> > While freeing indirect blocks we attach a journal head to the parent buffer
> > head, free the blocks, then journal the parent. If the indirect block list
> > is corrupted and points to the parent the journal head will be detached
> > when the block is cleared, causing an OOPS.
> > 
> > Check for that explicitly and handle it gracefully.
> > 
> > This patch fixes the third case (image hdb.20000057.nullderef.gz)
> > reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.
> 
> Thanks.
> 
> Quite a few minorish ext3 fixes are coming in lately.  Is anyone
> checking whether they are needed in ext4 and if so, porting them
> over?
> 
Hi Andrew, thanks for the reminder, I checked and think there are a few
latest ext3 fixes need to port to ext4..


> -mm's current queue is:
> 
> ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
> ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
> ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

These three (ext4 version) have been pushed to Linus tree(May 14th)

> jbd-replace-potentially-false-assertion-with-if-block.patch

Ext4 has this fix in upstream already

> jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
> jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch

Pushed to Linus already

> ext3-improve-some-code-in-rb-tree-part-of-dirc.patch

Ext4 version is queued in ext4 patch queue

> jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
> jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
> jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd2 version is not needed with new ordered mode rewrite

> ext3-remove-double-definitions-of-xattr-macros.patch
ext4 version is in ext4 patch queue

> ext3-handle-corrupted-orphan-list-at-mount.patch
> ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
> ext3-handle-corrupted-orphan-list-at-mount-fix.patch
> ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
> ext3-dont-read-inode-block-if-the-buffer-has-a-write-error.patch
> ext3-handle-deleting-corrupted-indirect-blocks.patch
> 

These haven't port to ext4 yet. I could port them to ext4 if no one
wants to do so.

Mingming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

