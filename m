From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/22] jbd2: Checksum revocation blocks
Date: Mon, 12 Dec 2011 10:39:35 -0500
Message-ID: <20111212153935.GA13213@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232829.19194.79159.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46186 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1LLPjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 10:39:40 -0500
Content-Disposition: inline
In-Reply-To: <20111128232829.19194.79159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:28:29PM -0800, Darrick J. Wong wrote:
> +				/*
> +				 * Ignoring corrupt revoke blocks is safe
> +				 * because at worst it results in unnecessary
> +				 * writes during recovery.
> +				 */

This is *not* true.  The reason why we have revoke blocks is because
we have to handle the case where a metadata block (which is journaled)
is released, and then the block is reused as a data block.  If we then
replay the block, the "unnecessary write" will result the potential
corruption of a data block.

So if we lose a revoke block, it's not possible to safely replay *any*
part of the journal.  E2fsck might be able to do something about it by
saving the old copy of all blocks written during the journal replay if
it detects this case, and then alerting the system administrator that
a particular data file may have gotten corrupted.  But it's going to
be really messy...

						- Ted
