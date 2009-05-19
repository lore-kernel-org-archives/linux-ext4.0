From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Tue, 19 May 2009 13:49:01 -0400
Message-ID: <20090519174901.GB9053@mit.edu>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43416 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZESRtI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 13:49:08 -0400
Content-Disposition: inline
In-Reply-To: <20090519171430.GA26480@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 19, 2009 at 07:14:30PM +0200, Jan Kara wrote:
> > EXT3: Change all super.c messages to print the device
> > 
> > I had a problem where it was unclear to which device a ext3 message belonged.
> > Not all of them them print it.
> > 
> > This patch changes ext3 super.c to include the device name with all 
> > warning/error messages, by using a new utility function ext3_msg. 
> > It's a rather large patch, but very mechanic. I left debug printks
> > alone.
> > 
> > The normal mount output looks a little more regular now because near all
> > messages are in the same format.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
>   Ted, did you pick up this cleanup? I don't see any reply or the patch
> being merged... The cleanup looks nice.

No, I didn't but thanks for reminding me; I agree it's a good cleanup.
We should get it ported over to ext4, too.

					- Ted
