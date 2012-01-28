From: WIMPy <WIMPy@yeti.dk>
Subject: Re: [dm-devel] can't recover ext4 on lvm from =?utf-8?b?ZXh0NF9tYl9nZW5lcmF0ZV9idWRkeTo3Mzk6?= group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Sat, 28 Jan 2012 21:04:29 +0000 (UTC)
Message-ID: <loom.20120128T215220-189@post.gmane.org>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org> <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com> <loom.20120128T050950-718@post.gmane.org> <loom.20120128T090712-530@post.gmane.org> <EBC820CD-E86F-48BB-ADA3-38B5C8A75187@dilger.ca> <loom.20120128T162211-867@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48387 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab2A1VEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jan 2012 16:04:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1RrFRv-0004wq-2r
	for linux-ext4@vger.kernel.org; Sat, 28 Jan 2012 22:04:39 +0100
Received: from e183095026.adsl.alicedsl.de ([85.183.95.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 22:04:39 +0100
Received: from WIMPy by e183095026.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 22:04:39 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

... and another update:

> As there was a mention at the beginning that this may have happened after an 
> upgrade from 3.1.5 to 3.2, I will build a 3.1.5 and see if that really makes 
a 
> difference.

Yes it does.
3.1.5 has been working for 4.5 hours now, continuing form the point where 3.2 
and 3.2.2 reproducibly barfed.
I see some changes to ext4 on January 9 and 10. But nothing thereafter so I'm 
not sure if it's worth trying something like 3.3-rc1.
The bad thing is that 3.2 has been working for about 20 hours, so it's not a 
quick test.

> > >>>>> this is a problem which apparently occurred when the user went from
> > >>>> v3.1.5 to v3.2, so this looks likes 3.2 regression.)

> > >> It happened for me on a freshly created FS.
> > >> "mke2fs -j -O sparse_super -O dir_index -O extents -O filetype -O uninit_
> bg"
> > >> mounted with no additional options for the first time I got an
> > >> "EXT4-fs error (device md127): ext4_mb_generate_buddy:739: group 28671, 
> 32765 
> > >> clusters in bitmap, 32766 in gd"
> > >> after writing about 3TB of data.
> > >> I do not have RO snapshots as the OP, but my md sits on top of luks 
> > > containers. 
> > >> So we do have the device mapper in common.
> > > 
> > > After I did an fsck and tried to continue, I didn't get that far.
> > > After another 200GB or so it happened again.
> > > And now it's reproducible:
> > > I can run fsck and then try to continue (using rsync). But as soon as 
> writing 
> > > starts, the process hangs for a long time. At least one minute, probably 
> longer.
> > > Then the ext4_mb_generate_buddy comes again.

  Greetings,
    WIMPy


