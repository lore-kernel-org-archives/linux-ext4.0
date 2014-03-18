From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
Date: Tue, 18 Mar 2014 18:28:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403181820220.2121@localhost.localdomain>
References: <1395155370.15587.9.camel@zerobox.home> <20140318171425.GC8506@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lubos Uhliarik <uhliarik@seznam.cz>, linux-ext4@vger.kernel.org,
	vojnar@fit.vutbr.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaCRR2u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 13:28:50 -0400
In-Reply-To: <20140318171425.GC8506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 18 Mar 2014, tytso@mit.edu wrote:

> Date: Tue, 18 Mar 2014 13:14:26 -0400
> From: tytso@mit.edu
> To: Lubos Uhliarik <uhliarik@seznam.cz>
> Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com, vojnar@fit.vutbr.cz
> Subject: Re: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
> 
> On Tue, Mar 18, 2014 at 04:09:30PM +0100, Lubos Uhliarik wrote:
> > The main changes in patch are following:
> > 
> > a) commented out zeroing ex->ee_len, ee->start_hi and ee->start_lo,
> > because these entries are essential for undelete process
> 
> The reason why we have to zero out ex->ee_len, etc. is because the
> truncate operation can sometimes span multiple journal transactions.
> So as a result, we need to keep the file system consistent if we are
> interrupted (i.e., via a power fail event) while in the middle of a
> truncate operation.
> 
> It's a rare case, but it can happen if the journal is almost full at
> the time when the truncate eoperation has started, such that there is
> no room for to exntend the transaction handle, and so we are forced to
> start a new transaction (and possibly wait for a journal checkpoint
> operation).
> 
> In theory, it would be possible to figure out in advance whether or
> not we could fit the truncate in a single transaction, but it would
> require making the truncate operation be a two-pass operation --- once
> to determine how many blocks needs to be modified, and once to
> actually do the truncate operation.

Hi Lubos,

that's what we've been discussing including the power failure
testing. Have you managed to make a power failure test for this ? I
kind of forgot to ask you about that today.

Also, if I recall correctly you mentioned that we should be ok with
the respect of power failure in the middle of truncate, but I do not
recall the details, can you try to look into that again ?

Thanks!
-Lukas

> 
> > This patch shouldn't break ext4, I tested it with xfs_tests and tests 
> > were successfull.
> 
> I'm guessing you didn't do power fail testing --- and this is very
> important when messing with the design truncate/unlink code path.
> 
> Regards,
> 
> 						- Ted
> 
