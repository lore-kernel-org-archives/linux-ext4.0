From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
	for FLEX_BG
Date: Tue, 22 Apr 2008 10:51:25 -0400
Message-ID: <20080422145125.GB12836@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu> <1208868379-17580-2-git-send-email-tytso@mit.edu> <1208868379-17580-3-git-send-email-tytso@mit.edu> <20080422091847.50708436@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43735 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763015AbYDVOv5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 10:51:57 -0400
Content-Disposition: inline
In-Reply-To: <20080422091847.50708436@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 22, 2008 at 09:18:47AM -0500, Jose R. Santos wrote:
> > @@ -1638,6 +1654,19 @@ static void PRS(int argc, char *argv[])
> > 
> >  	if (inode_size == 0)
> >  		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
> > +	if (!flex_bg_size && (fs_param.s_feature_incompat &
> > +			      EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > +		get_int_from_profile(fs_types, "flex_bg_size", 8);
> 
> A default of 256 block groups to pack seems a bit high base on some of
> the performance testing that I've done.  At some point having the inodes
> too far away from the data blocks begins to affect performance
> (especially on read operations).  The optimum number of groups depends
> a lot on platter density of the hard drive so I expect that we can
> increase the default grouping size as time goes by.  Using 128 groups
> as already showing performance degradation on read operations on some
> of my smaller disks (147GB).  For now, I would change this to 6 (64
> groups) as this is a good balance for both big an small disks.

Actually this is 8 (as in 2**3), which was intentionally very small,
because I was being conservative.  I could change it to be 64 if you
think it is a better balance.  As you can see, it gets set later on
down here.

> > +		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);

And, in fact the biggest bug which both you and I missed was that this:

> > +		get_int_from_profile(fs_types, "flex_bg_size", 8);

Should have been this:

       	    flex_bg_size = get_int_from_profile(fs_types, "flex_bg_size", 8);

<Dons paper bag>

						- Ted
