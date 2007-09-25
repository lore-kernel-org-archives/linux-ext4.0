From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 22:57:23 +0200
Message-ID: <20070925205723.GG2806@petra.dvoda.cz>
References: <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org> <20070925091400.GA2806@petra.dvoda.cz> <1190715083.3373.79.camel@lov.localdomain> <20070925123454.GE2806@petra.dvoda.cz> <1190751950.3773.23.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbXIYU5b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 16:57:31 -0400
Content-Disposition: inline
In-Reply-To: <1190751950.3773.23.camel@lov.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 10:25:50PM +0200, Kay Sievers wrote:
> On Tue, 2007-09-25 at 14:34 +0200, Karel Zak wrote:
> > On Tue, Sep 25, 2007 at 12:11:23PM +0200, Kay Sievers wrote:
> > > On Tue, 2007-09-25 at 11:14 +0200, Karel Zak wrote:
> > > >  Now we duplicate a lot of FS probe code in libblkid, libvolume_id and
> > > >  libdisk.
> > > > 
> > > >  Yes, it's long-term task, but it's good direction (IMHO).
> > > 
> > > It is, and we are not providing a real value to the users by providing
> > > both of these libs at the same time. :)
> > > 
> > > But udev has a very different requirement for probing filesystems.
> > > Unlike non-udev systems, we can't accept any hidden policy inside a
> > > library. We just want to pass a byte stream to the lib, and get back
> > > what exactly is in _this_ byte stream. There must be no chaching, no
> > > devmapper logic, no stat()'ing in /dev, no reading of /proc/partitions,
> > > no ioctl()'s, no hidden decisions, nothing. None of these actions is
> > > acceptable to be done by the library itself, if udev is used. We need
> > > pure mechanics, no policy. We also need an API that allows to specify
> > > the size of the stream and the probing offset. And we don't want to
> > > iterate over tags, need the filesystem version information, the raid
> > > metadata probing, and the classification volume_id provides.
> > 
> >  Technical details :-)
> 
> What do you miss, these are all technical details. :) In simple words,
> we need a completely policy-free, not try-to-be-smart in any sense set
> of functions to identify a bytestream by magic bytes.

 Yes, I've read libvolume_id code and I good understand what you mean.

> >  Cool. I'd like to create libfsprobe as an independent project. Or is
> >  there any advantage to merge everything to util-linux-ng? I don't
> >  think so.
> 
> Hmm, only if you reaqlly don't want to pull it in util-linux, we could
> have it as a separate tree. I still think util-linux is the best place,
> because the most important user of it is mount/fsck. It's your call, I
> would have no problem sending patches against util-linux. :)

 OK, Ted has same opinion and I'm not so stubborn... Let's use
 util-linux-ng.

 (I think we can continue with this topic at util-linux-ng mailing
 list only.)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
