From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 11:20:32 -0400
Message-ID: <20070925152032.GB2807@thunk.org>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org> <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org> <20070925091400.GA2806@petra.dvoda.cz> <1190715083.3373.79.camel@lov.localdomain> <20070925123454.GE2806@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55610 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXIYUVO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 16:21:14 -0400
Content-Disposition: inline
In-Reply-To: <20070925123454.GE2806@petra.dvoda.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2007 at 02:34:54PM +0200, Karel Zak wrote:
> > That means that we could replace the "low-level" part of libblkid with
> > volume_id code, and keep the current API of blkid, but offer some of the
> > low-level functionality for udev. Or we would implement the relevant
> > parts and probers in blkid, and add a new API to access the low-level
> > part directly.
> 
>  I don't see a problem to provide low-level and high-level interface in
>  same library. The low-level stuff (fsprobe code) is still same.

Agreed, one interface and one code base for determining "what is this
filesystem is a good thing".

>  Things like a cache are discussable -- for example resolve LABEL/UUID
>  on system with udev is faster by /dev/disk/by-*. I think a good
>  library has to be smart enough to found the fastest way how translate
>  LABEL/UUID to device name.

It depends on what you're doing, actually.  If you want to resolve
multiple UUID's, it will be faster to use the cache, since it's in
memory.  And the blkid cache will allow you to do things like find all
devices with a particular filesystem type, etc.  And although blkid
doesn't do this now, it's a more flexible model for handling things
like "to find the ext3 journal with UUID=XXXX-...-XXXX", use this
iSCSI device at this IP address.  Assuming that you can always probe
all 30,000 devices and populate /dev/disk/by-* at boot time is not
necessarily something that I would consider scalable; if you have
hundreds of thousands of LUN's connected to a storage array that
aren't mounted at boot time, and only mounted on demand when a
particular LUN is needed, I think the udev model doesn't fit all that
well.

>  Cool. I'd like to create libfsprobe as an independent project. Or is
>  there any advantage to merge everything to util-linux-ng? I don't
>  think so.

My main concern is avoiding what the "GNOME library problem".  Huge
numbers of independent projects makes build dependencies incredibly
painful.  And of course, any time we do this kind of factoring we need
to keep the interfaces stable.  In userspace, with published, stable
API's are not nonsense, but an absolute and unconditional requirement.

     	      		       		    		  - Ted
