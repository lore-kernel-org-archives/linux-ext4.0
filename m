From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Return error code from generic_check_addressable
Date: Mon, 22 Nov 2010 19:27:59 +0100
Message-ID: <20101122182759.GA6141@quack.suse.cz>
References: <20101115214831.GA18195@tux1.beaverton.ibm.com>
 <4CE1AC38.9040201@redhat.com>
 <20101115230346.GB18195@tux1.beaverton.ibm.com>
 <alpine.LFD.2.00.1011161351230.5515@dhcp-lab-213.englab.brq.redhat.com>
 <20101116225744.GD18195@tux1.beaverton.ibm.com>
 <alpine.LFD.2.00.1011180946020.3125@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	"Patrick J. LoPresti" <lopresti@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53792 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0KVS2C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 13:28:02 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011180946020.3125@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-11-10 09:52:51, Lukas Czerner wrote:
> On Tue, 16 Nov 2010, Darrick J. Wong wrote:
> 
> > ext3: Return error code from generic_check_accessible
> > 
> > ext3_fill_super should return the error code that generic_check_accessible
> > returns when an error condition occurs.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> >  fs/ext3/super.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > index 2fedaf8..960629b 100644
> > --- a/fs/ext3/super.c
> > +++ b/fs/ext3/super.c
> > @@ -1842,13 +1842,15 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
> >  		goto failed_mount;
> >  	}
> >  
> > -	if (generic_check_addressable(sb->s_blocksize_bits,
> > -				      le32_to_cpu(es->s_blocks_count))) {
> > +	err = generic_check_addressable(sb->s_blocksize_bits,
> > +					le32_to_cpu(es->s_blocks_count));
> > +	if (err) {
> >  		ext3_msg(sb, KERN_ERR,
> >  			"error: filesystem is too large to mount safely");
> >  		if (sizeof(sector_t) < 8)
> >  			ext3_msg(sb, KERN_ERR,
> >  				"error: CONFIG_LBDAF not enabled");
> > +		ret = err;
> >  		goto failed_mount;
> >  	}
> >  
> > 
> 
> Add Jan Kara to cc list.
  Thanks for forwarding. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
