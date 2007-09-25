From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 12:11:23 +0200
Message-ID: <1190715083.3373.79.camel@lov.localdomain>
References: <20070919061404.GA1628@schatzie.adilger.int>
	 <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int>
	 <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org>
	 <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org>
	 <20070925091400.GA2806@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:45332 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbXIYKL3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 06:11:29 -0400
In-Reply-To: <20070925091400.GA2806@petra.dvoda.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-25 at 11:14 +0200, Karel Zak wrote:
> On Mon, Sep 24, 2007 at 08:40:36AM -0400, Theodore Tso wrote:
> > On Mon, Sep 24, 2007 at 11:25:39AM +0200, Karel Zak wrote:
> > > > 
> > > > Nope, there isn't much rationale unless we also split out fsck, so
> > > 
> > >  util-linux-ng is open for fsck :-)
> > 
> > It's something I'm considering, but at the moment I've got some higher
> > priority (ext4) work that I'm focusing on.  
> 
>  That's nothing urgent. This migration shouldn't be so difficult -- I
>  think we should provide at least one release when the util is in both
>  packages -- defaultly disabled in e2fsprogs and enabled in
>  util-linux-ng. It's probably better that trying to synchronize
>  releases of both packages.
> 
> > What would you think about moving libblkid and the libdisk from
> > xfsprogs into util-linux-ng?  That's things that I've been batting
> 
>  I have no problem with this idea, but I'd like to invite Kay Sievers
>  (udev) to this discussion. I think the best step will be merge
>  libblkid and libvolume_id to the one independent project.

Oh, I would be fine with putting that in util-linux. Mount is the most
critical user, so it has it's place there from my point of view. And
having mount and fsck in util-linux, sharing the fsprobing code and
fstab-parsing code sounds great to me.

> There is
>  few technical problems with this idea, but nothing insolvable.

I'm all for doing this, and don't see any real problem with that. I
talked to Ted a few weeks ago when we met in person about this already.

>  Now we duplicate a lot of FS probe code in libblkid, libvolume_id and
>  libdisk.
> 
>  Yes, it's long-term task, but it's good direction (IMHO).

It is, and we are not providing a real value to the users by providing
both of these libs at the same time. :)

But udev has a very different requirement for probing filesystems.
Unlike non-udev systems, we can't accept any hidden policy inside a
library. We just want to pass a byte stream to the lib, and get back
what exactly is in _this_ byte stream. There must be no chaching, no
devmapper logic, no stat()'ing in /dev, no reading of /proc/partitions,
no ioctl()'s, no hidden decisions, nothing. None of these actions is
acceptable to be done by the library itself, if udev is used. We need
pure mechanics, no policy. We also need an API that allows to specify
the size of the stream and the probing offset. And we don't want to
iterate over tags, need the filesystem version information, the raid
metadata probing, and the classification volume_id provides.

That means that we could replace the "low-level" part of libblkid with
volume_id code, and keep the current API of blkid, but offer some of the
low-level functionality for udev. Or we would implement the relevant
parts and probers in blkid, and add a new API to access the low-level
part directly.

Note, that even with only one fsprobing library, util-linux would still
need to behave differently on a udev system, because we can't afford to
maintain a cache file, or search for anything else at event time, on
systems with 20.000 hard disks connected. But systems without udev will
obviously need the "search all devices" functionality of blkid to find
labels and uuid's.

Let me know what you think how go ahead with this, I'm all for doing
this sooner than later.

Cheers,
Kay
