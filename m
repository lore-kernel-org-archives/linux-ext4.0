From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Tue, 12 Nov 2013 15:03:35 -0800
Message-ID: <20131112230335.GA10269@birch.djwong.org>
References: <1383808590.23882.13.camel@chiang>
 <20131107160341.GA3850@quack.suse.cz>
 <1383864864.23882.33.camel@chiang>
 <20131107231445.GG2054@quack.suse.cz>
 <1383866807.23882.41.camel@chiang>
 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
 <1383981551.8994.27.camel@chiang>
 <CADQUmxULoLgXRyoPpJJMJLqJPsZ8M4oPP8ScGxWp+Np8-efq3g@mail.gmail.com>
 <1384070214.8994.47.camel@chiang>
 <20131112003018.GA30281@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>,
	David Turner <novalis@novalis.org>, Mark Harris <mhlk@osj.us>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18883 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3KLXDq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Nov 2013 18:03:46 -0500
Content-Disposition: inline
In-Reply-To: <20131112003018.GA30281@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 11, 2013 at 07:30:18PM -0500, Theodore Ts'o wrote:
> On Sun, Nov 10, 2013 at 02:56:54AM -0500, David Turner wrote:
> > b. Use Andreas's encoding, which is incompatible with pre-1970 files
> > written on 64-bit systems.
> >
> > I don't care about currently-existing post-2038 files, because I believe
> > that nobody has a valid reason to have such files.  However, I do
> > believe that pre-1970 files are probably important to someone.
> > 
> > Despite this, I prefer option (b), because I think the simplicity is
> > valuable, and because I hate to give up date ranges (even ones that I
> > think we'll "never" need). Option (b) is not actually lossy, because we
> > could correct pre-1970 files with e2fsck; under Andreas's encoding,
> > their dates would be in the far future (and thus cannot be legitimate).
> > 
> > Would a patch that does (b) be accepted?  I would accompany it with a
> > patch to e2fsck (which I assume would also go to the ext4 developers
> > mailing list?).
> 
> I agree, I think this is the best way to go.  I'm going to drop your
> earlier patch, and wait for an updated patch from you.  It may miss
> this merge window, but as Andreas has pointed out, we still have a few
> years to get this right.  :-)

Just to be clear... we're going with Andreas' fix, wherein

time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;

becomes:

time->tv_sec += (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK) << 32;

"or" becomes "plus"?  So I can update fuse2fs.

Also, can someone proofread [1] and make sure it's correct?

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Inode_Timestamps
> 
> Thanks!!
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
