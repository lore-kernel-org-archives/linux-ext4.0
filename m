From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] EXT4: Avoid double dirtying of super block in
	ext4_put_super()
Date: Mon, 6 Oct 2008 19:39:49 -0400
Message-ID: <20081006233949.GB9337@mit.edu>
References: <20081006212118.GA382@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37405 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698AbYJFXjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 19:39:51 -0400
Content-Disposition: inline
In-Reply-To: <20081006212118.GA382@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 11:21:18PM +0200, Andi Kleen wrote:
> EXT4: Avoid double dirtying of super block in ext4_put_super()
> 
> While reading code I noticed that ext4_put_super() dirties the 
> superblock bh twice. It is always done in ext4_commit_super()
> too. Remove the redundant dirty operation.
> 
> Should be a nop semantically.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

As it turns out, I had taken out the mark_buffer_dirty as superfluous
in the following patch:

    ext4/jbd2: Avoid WARN() messages when failing to write to the superblock

(This was Arjan's favorite ext3/ext4 top-ten kerneloops.org bug).

However I didn't kill the BUFFER_TRACE(sbi->s_sbh, "marking dirty");
line, which should have been deleted too.  I'll take out the change
from my patch since it's really unrelated to fixing the kerneloops.org
WARN'ing, and take your patch and it include it for submission to
Linus in the ext3 tree.

Thanks,

						- Ted
