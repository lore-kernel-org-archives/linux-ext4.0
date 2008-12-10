From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V3 2/3] quota: Add quota claim and release reserved
	quota
Date: Wed, 10 Dec 2008 12:21:40 +0100
Message-ID: <20081210112139.GB17998@duck.suse.cz>
References: <20081203190639.GD12803@duck.suse.cz> <1228787362.6372.41.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42831 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbYLJLVl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2008 06:21:41 -0500
Content-Disposition: inline
In-Reply-To: <1228787362.6372.41.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-12-08 17:49:22, Mingming Cao wrote:
> > > +	/* Dirtify all the dquots - this can block when journalling */
> > > +	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
> > > +		if (inode->i_dquot[cnt])
> > > +			mark_dquot_dirty(inode->i_dquot[cnt]);
> > > +	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
> > > +
> > > +	/* Update inode bytes */
> > > +	inode_add_bytes(inode, number);
> >   And this should be called from under dq_data_lock from
> > dquot_claim_reserved_space().
> >   BTW: This reminds me that you should also modify dquot_transfer() function.
> > Because that should not only transfer i_blocks sectors from one user
> > to another but it has to also transfer the amount reserved for that inode...
> > I think the easiest way around this would be to change i_blocks already when
> > reservation is acquired (and than substract it when some of it is given back).
> > 
> 
> I did looked at dquot_transfer() (not very deep though) before, I wasn't
> sure who is calling/needs dquot_transfer()? I noticed ext23 has the
> transfer operation defined, but I dont see it's being used. Any hint?
  ext[34]_setattr() calls DQUOT_TRANSFER() when owner of an inode is being
changed. This function subtracts the amount of space file occupies from
originating user and adds it to the destination user.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
