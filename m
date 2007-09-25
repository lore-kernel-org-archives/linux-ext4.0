From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 14:34:54 +0200
Message-ID: <20070925123454.GE2806@petra.dvoda.cz>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org> <20070925091400.GA2806@petra.dvoda.cz> <1190715083.3373.79.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbXIYMe6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 08:34:58 -0400
Content-Disposition: inline
In-Reply-To: <1190715083.3373.79.camel@lov.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 12:11:23PM +0200, Kay Sievers wrote:
> On Tue, 2007-09-25 at 11:14 +0200, Karel Zak wrote:
> >  Now we duplicate a lot of FS probe code in libblkid, libvolume_id and
> >  libdisk.
> > 
> >  Yes, it's long-term task, but it's good direction (IMHO).
> 
> It is, and we are not providing a real value to the users by providing
> both of these libs at the same time. :)
> 
> But udev has a very different requirement for probing filesystems.
> Unlike non-udev systems, we can't accept any hidden policy inside a
> library. We just want to pass a byte stream to the lib, and get back
> what exactly is in _this_ byte stream. There must be no chaching, no
> devmapper logic, no stat()'ing in /dev, no reading of /proc/partitions,
> no ioctl()'s, no hidden decisions, nothing. None of these actions is
> acceptable to be done by the library itself, if udev is used. We need
> pure mechanics, no policy. We also need an API that allows to specify
> the size of the stream and the probing offset. And we don't want to
> iterate over tags, need the filesystem version information, the raid
> metadata probing, and the classification volume_id provides.

 Technical details :-)

> That means that we could replace the "low-level" part of libblkid with
> volume_id code, and keep the current API of blkid, but offer some of the
> low-level functionality for udev. Or we would implement the relevant
> parts and probers in blkid, and add a new API to access the low-level
> part directly.

 I don't see a problem to provide low-level and high-level interface in
 same library. The low-level stuff (fsprobe code) is still same.

 Things like a cache are discussable -- for example resolve LABEL/UUID
 on system with udev is faster by /dev/disk/by-*. I think a good
 library has to be smart enough to found the fastest way how translate
 LABEL/UUID to device name.

 But, it's too early to talk about details.

> Let me know what you think how go ahead with this, I'm all for doing
> this sooner than later.

 Cool. I'd like to create libfsprobe as an independent project. Or is
 there any advantage to merge everything to util-linux-ng? I don't
 think so.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
