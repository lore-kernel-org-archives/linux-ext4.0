From: Lubos Uhliarik <uhliarik@seznam.cz>
Subject: Re: [RFC][PATCH 0/1] ext4: Undelete Feature for Ext4
Date: Thu, 08 May 2014 23:11:26 +0200
Message-ID: <1399583486.8729.42.camel@zerobox.home>
References: <1395155370.15587.9.camel@zerobox.home>
	 <20140318171425.GC8506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com,
	vojnar@fit.vutbr.cz
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:52661 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbaEHTLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 May 2014 15:11:44 -0400
In-Reply-To: <20140318171425.GC8506@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tytso

I'm trying to respond on your email ones again - more in detail.

tytso@mit.edu wrote:
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

Yes, as I noticed in the function ext4_ext_rm_leaf in /fs/ext4/extents.c
file, there is a call of the function ext4_ext_truncate_extend_restart,
which can cause, that unlink operation will be devided into multiple
journal operations.

But, there should NOT be any problem with file system consistency in my
opinion, because decremention value of eh->eh_entries is in the same
transaction, as the block of code which will keep ex->ee_len, etc.
entries. 

So, if a new transaction is started, in eh->eh_entries will be correct
value of extents, which are in a block. 

New value of eh->eh_entries after decreasing after one iteration (one
extent removal) is written to the disk together with change of block
bitmap.

Between lines 2698
if (num == 0)
	/* this extent is removed; mark slot entirely unused */
	ext4_ext_store_pblock(ex, 0);

and 2727 

le16_add_cpu(&eh->eh_entries, -1);

in file fs/ext4/extents.c is no function call, which can mark block
dirty. That kind of function (ext4_ext_dirty) is called at line 2731. 

> 
> In theory, it would be possible to figure out in advance whether or
> not we could fit the truncate in a single transaction, but it would
> require making the truncate operation be a two-pass operation --- once
> to determine how many blocks needs to be modified, and once to
> actually do the truncate operation.




> 
> > This patch shouldn't break ext4, I tested it with xfs_tests and tests 
> > were successfull.
> 
> I'm guessing you didn't do power fail testing --- and this is very
> important when messing with the design truncate/unlink code path.

I did power failure testing, but I was unable to divide undelete process
into more transactions. I created the ext4 with the smallest possible
journal, but it didn't help, even I was creating and deleting 20 very
fragmented files at one moment. I didn't get any file system error,
which couldn't be repaired by replaying the journal. Anyway, as I wrote
before, I checked the code and I didn't see any problem, why it should
cause file system inconsistency.

If you have any questions, please ask me and I will try to respond
immediately, because my profesor needs to know, if this patch can be
considered as a part of next kernel version. Thank you. 

> 
> Regards,
> 
> 						- Ted

Kind regards,
Lubos


