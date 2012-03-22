From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/5] ext4: Correctly handle EOFBLOCKS flag in
 ext4_ext_punch_hole
Date: Thu, 22 Mar 2012 09:25:15 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203220826020.4904@dhcp-27-109.brq.redhat.com>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com> <1332314639-22875-2-git-send-email-lczerner@redhat.com> <20120322021305.GE11157@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	achender@linux.vnet.ibm.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab2CVIZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 04:25:22 -0400
In-Reply-To: <20120322021305.GE11157@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 Mar 2012, Ted Ts'o wrote:

> On Wed, Mar 21, 2012 at 08:23:55AM +0100, Lukas Czerner wrote:
> > +	/*
> > +	 * This is fugly, but even though we're going to get rid of the
> > +	 * EOFBLOCKS_LF in the future, we have to handle it correctly now
> > +	 * because there are still versions of e2fsck out there which
> > +	 * would scream otherwise. Once the new e2fsck code ignoring
> > +	 * this flag is common enough this can be removed entirely.
> > +	 */
> > +	if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)) {
> > +		struct ext4_ext_path *path;
> > +		ext4_lblk_t last_block;
> > +
> > +		mutex_lock(&inode->i_mutex);
> > +		down_read(&EXT4_I(inode)->i_data_sem);
> 
> I was looking at this patch, and I was wondering why we weren't taking
> i_mutex earlier in ext4_ext_punch_hole().  The primary use of i_mutex
> is to protect writes racing with each other and with truncate.  Given
> that punch essentially works like truncate, and all of ext4_truncate()
> is run with i_mutex down, and currently ext4_ext_punch_hole() (before
> applying this patch) doesn't isn't taking i_mutex at all, I'm
> wondering if we can run into problems where punch is racing against a
> write --- if the pages are already in mapped, then the write might not
> even need to take i_data_sem.
> 
> Lukas, Allison --- am I missing something here?
> 
> 						- Ted

Hmm, so we can not race with truncate since we do not touch i_size in
punch_hole and the extent tree modification is done with i_data_sem
locked.

As far as write is concerned, I do not think that race is possible. If
for example we're trying to write into the same range we're punching out
the buffer we're trying to write into is either mapped, or not right ?

If it's mapped then punch_hole did not get to this block yet, but it
will eventually in the current transaction. If the buffer is unmapped,
then we're going to get a new block, which means we're going to have to
lock the i_data_sem, but since punch_hole is already holding it we have
to wait before it finishes.

The worse what can happen is that after a write spanning several block
we'll have first part of the write punched out, but second part written
correctly since in this case it might hit already punched block
and need to wait for punch_hole to finish, after that the rest of the
range is written. However the write should remain consistent on block
granularity which is all we guarantee anyway, right ?

-Lukas
