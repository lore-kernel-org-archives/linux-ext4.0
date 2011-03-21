From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 03/12] ext4: Convert instances of
 EXT4_BLOCKS_PER_GROUP to EXT4_CLUSTERS_PER_GROUP
Date: Mon, 21 Mar 2011 09:12:11 -0400
Message-ID: <20110321131211.GH4135@thunk.org>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
 <1300570117-24048-4-git-send-email-tytso@mit.edu>
 <AANLkTik962xWpBCaFgfu9Xm0YkPJ8+RwTJH9Oj48Wh2r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50605 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab1CUNMP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 09:12:15 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTik962xWpBCaFgfu9Xm0YkPJ8+RwTJH9Oj48Wh2r@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 20, 2011 at 12:26:57PM +0200, Amir Goldstein wrote:
> If I am not mistaken, while 'bit' was already converted to cluster units,
> 'count' is still in block units.
> 
> I think ext4_free_blocks() need to do 2 things:
> 1. convert 'count' to clusters (after issuing journal_forget())
> 2. round 'bit' up (and round 'count' down) if start block is not
> on cluster boundary, so truncate/punch hole, will not free a
> cluster when it's 'base' block is still allocated.

Good catch!  It's actually more complicated than that, though.
Whether or not we can free the first and the last cluster in an
unaligned extent is going to depend on whether or not there are any
blocks still in use --- which is something that has to be communicated
by extents.c, since mballoc has no way of knowing this.  (Consider
what happens with sparse blocks.)  What I think I'm going to have to
do is to teach truncate to check to see whether this is an unaligned
truncate, and if so, whether there are any blocks still left used.  If
so, it will need to pass a flag to ext4_free_blocks() to tell it to
skip the first incomplete cluster.

Similarly, when the punch code lands, we'll need to worry about this
at the end of the region which gets "punched" out, and we'll need a
similar flag telling ext4_free_blocks() whether or not to release the
last incomplete cluster.

Thanks for catching this; I have a bit more coding work to do to deal
with this case.

						- Ted
