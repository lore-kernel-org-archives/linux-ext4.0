From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Mon, 27 Feb 2012 12:00:11 -0500
Message-ID: <20120227170011.GB1651@thunk.org>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com>
 <1330072490-26833-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, psusi@ubuntu.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46680 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab2B0RAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 12:00:13 -0500
Content-Disposition: inline
In-Reply-To: <1330072490-26833-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 09:34:50AM +0100, Lukas Czerner wrote:
> Previously when running e2fsck with '-E discard' argument the end of
> the last group has not been discarded. This patch fixes it so we
> always discard the end of the last group if needed.
> 
> This commit also removes unneeded argument from the
> e2fsck_discard_blocks(). Simultaneously the commit causes the block
> groups with BLOCK_UNINIT flag not to be discarded, which makes
> since because we do not need to reclaim the space since so far
> there has not been written anything.

Let me ask the question Phillip is asking a different way.  What's the
*benefit* in not issuing a discard for blocks in block groups where
the block bitmap is marked as unitialized, as opposed to simply
issuing discard for all blocks that are not marked as in use?  Are you
trying to optimize the amount of time that the storage device spends
processing the trim commands?  Do you think issuing discards on space
that is already discarded will somehow cause more wear on SSD's?

     			       	       	     	  - Ted
