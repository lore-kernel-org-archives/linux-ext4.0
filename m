From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: handle deleting corrupted indirect blocks
Date: Tue, 24 Jun 2008 14:05:51 -0700
Message-ID: <20080624140551.567149b6.akpm@linux-foundation.org>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	<1214315240-22950-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@clusterfs.com, sliedes@cc.hut.fi,
	duaneg@dghda.com
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbYFXVGr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 17:06:47 -0400
In-Reply-To: <1214315240-22950-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Jun 2008 14:47:20 +0100
"Duane Griffin" <duaneg@dghda.com> wrote:

> While freeing indirect blocks we attach a journal head to the parent buffer
> head, free the blocks, then journal the parent. If the indirect block list
> is corrupted and points to the parent the journal head will be detached
> when the block is cleared, causing an OOPS.
> 
> Check for that explicitly and handle it gracefully.
> 
> This patch fixes the third case (image hdb.20000057.nullderef.gz)
> reported in http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Thanks.

Quite a few minorish ext3 fixes are coming in lately.  Is anyone
checking whether they are needed in ext4 and if so, porting them
over?

-mm's current queue is:

ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-remove-double-definitions-of-xattr-macros.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-dont-read-inode-block-if-the-buffer-has-a-write-error.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch

