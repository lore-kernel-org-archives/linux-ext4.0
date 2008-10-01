From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] ext3: Fix ext3_dx_readdir hash collision handling
Date: Wed, 1 Oct 2008 16:33:07 -0700
Message-ID: <20081001163307.11df5f30.akpm@linux-foundation.org>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
	<20080917121943.904b66b6.akpm@linux-foundation.org>
	<20081001223755.GL10080@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbYJAXdN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2008 19:33:13 -0400
In-Reply-To: <20081001223755.GL10080@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 1 Oct 2008 18:37:55 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Sep 17, 2008 at 12:19:43PM -0700, Andrew Morton wrote:
> > On Sat, 13 Sep 2008 11:32:48 -0400
> > "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> > 
> > > This fixes a bug where readdir() would return a directory entry twice
> > > if there was a hash collision in an hash tree indexed directory.
> > 
> > That sounds like a serious problem, but given the amount of time it
> > took to turn up, I guess it's pretty rare.
> > 
> > What are your thoughts regarding a 2.6.27 merge for this?  2.6.26.x? 
> > 2.6.25.x?  ...
> > 
> 
> It's not a regression, so per Linus's request that at this point we're
> too late for anything other than regression fixes, I had assumed that
> it should be pushed for 2.6.28, and then go into the various stable
> trees.  It's true that it took quite a while for people to notice,
> probably because many programs won't notice if readdir() returns a
> directory entry twice.

OK.

> BTW, this hasn't hit -mm yet, and I've got a number of ext3 patches
> that don't appear to have hit -mm, including one that was authored by
> Linus.  Should I create a git tree or a quilt series if that would
> make things easier for you?
> 

I currently have:

jbd-abort-when-failed-to-log-metadata-buffers.patch
#jbd-fix-error-handling-for-checkpoint-io.patch: double-check this
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch
ext3-dont-try-to-resize-if-there-are-no-reserved-gdt-blocks-left.patch
ext3-fix-ext3-block-reservation-early-enospc-issue.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
ext3-add-an-option-to-control-error-handling-on-file-data.patch
jbd-ordered-data-integrity-fix.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
ext3-truncate-block-allocated-on-a-failed-ext3_write_begin.patch
ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch
#jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch: sct probs
jbd-abort-instead-of-waiting-for-nonexistent-transactions.patch

and I don't see anything from yourself in the backlog?

There are some ext3 patches from other people I need to go through -
I've been offlineish for nearly a week and have spent a fun day staring
in horror at the mess which people are shovelling in Stephen's
direction for linux-next.

