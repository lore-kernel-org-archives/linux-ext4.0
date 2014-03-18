From: tytso@mit.edu
Subject: Re: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
Date: Tue, 18 Mar 2014 13:14:26 -0400
Message-ID: <20140318171425.GC8506@thunk.org>
References: <1395155370.15587.9.camel@zerobox.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com,
	vojnar@fit.vutbr.cz
To: Lubos Uhliarik <uhliarik@seznam.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43089 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbaCRRO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 13:14:58 -0400
Content-Disposition: inline
In-Reply-To: <1395155370.15587.9.camel@zerobox.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 18, 2014 at 04:09:30PM +0100, Lubos Uhliarik wrote:
> The main changes in patch are following:
> 
> a) commented out zeroing ex->ee_len, ee->start_hi and ee->start_lo,
> because these entries are essential for undelete process

The reason why we have to zero out ex->ee_len, etc. is because the
truncate operation can sometimes span multiple journal transactions.
So as a result, we need to keep the file system consistent if we are
interrupted (i.e., via a power fail event) while in the middle of a
truncate operation.

It's a rare case, but it can happen if the journal is almost full at
the time when the truncate eoperation has started, such that there is
no room for to exntend the transaction handle, and so we are forced to
start a new transaction (and possibly wait for a journal checkpoint
operation).

In theory, it would be possible to figure out in advance whether or
not we could fit the truncate in a single transaction, but it would
require making the truncate operation be a two-pass operation --- once
to determine how many blocks needs to be modified, and once to
actually do the truncate operation.

> This patch shouldn't break ext4, I tested it with xfs_tests and tests 
> were successfull.

I'm guessing you didn't do power fail testing --- and this is very
important when messing with the design truncate/unlink code path.

Regards,

						- Ted
