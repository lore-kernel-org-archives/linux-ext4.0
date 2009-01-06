From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V5 3/5]ext4: quota handling for delayed allocation
Date: Tue, 6 Jan 2009 10:39:36 +0100
Message-ID: <20090106093936.GF10705@duck.suse.cz>
References: <1231216855.9267.27.camel@mingming-laptop> <20090106093528.GE10705@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53599 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752215AbZAFJji (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 04:39:38 -0500
Content-Disposition: inline
In-Reply-To: <20090106093528.GE10705@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-01-09 10:35:29, Jan Kara wrote:
> On Mon 05-01-09 20:40:55, Mingming Cao wrote:
> > ext4: quota reservation for delayed allocation
> > 
> > Uses quota reservation/claim/release to handle quota properly for delayed
> > allocation in the three steps: 1) quotas are reserved when data being copied
> > to cache when block allocation is defered 2) when new blocks are allocated.
> > reserved quotas are converted to the real allocated quota, 2) over-booked
> > quotas for metadata blocks are released back.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>   The patch looks fine as far as I can tell :). But I'm not to familiar
> with the code so I won't add my Acked-by...
  On a second thought:

> > +unsigned long long ext4_get_reserved_space(struct inode *inode)
> > +{
> > +	unsigned long long total;
> > +
> > +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> > +	total = EXT4_I(inode)->i_reserved_data_blocks +
> > +		EXT4_I(inode)->i_reserved_meta_blocks;
> > +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +
> > +	return total;
> > +}
  Shouldn't we return here (total << inode->i_blksize)? Quota expects
bytes as output...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
