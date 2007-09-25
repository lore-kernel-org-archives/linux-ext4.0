From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 22:25:50 +0200
Message-ID: <1190751950.3773.23.camel@lov.localdomain>
References: <20070919061404.GA1628@schatzie.adilger.int>
	 <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int>
	 <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org>
	 <20070924092539.GC2819@petra.dvoda.cz> <20070924124035.GA4209@thunk.org>
	 <20070925091400.GA2806@petra.dvoda.cz>
	 <1190715083.3373.79.camel@lov.localdomain>
	 <20070925123454.GE2806@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andreas Dilger <adilger-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	List util-linux-ng <util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20070925123454.GE2806-CxBs/XhZ2BtHjqfyn1fVYA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-25 at 14:34 +0200, Karel Zak wrote:
> On Tue, Sep 25, 2007 at 12:11:23PM +0200, Kay Sievers wrote:
> > On Tue, 2007-09-25 at 11:14 +0200, Karel Zak wrote:
> > >  Now we duplicate a lot of FS probe code in libblkid, libvolume_id and
> > >  libdisk.
> > > 
> > >  Yes, it's long-term task, but it's good direction (IMHO).
> > 
> > It is, and we are not providing a real value to the users by providing
> > both of these libs at the same time. :)
> > 
> > But udev has a very different requirement for probing filesystems.
> > Unlike non-udev systems, we can't accept any hidden policy inside a
> > library. We just want to pass a byte stream to the lib, and get back
> > what exactly is in _this_ byte stream. There must be no chaching, no
> > devmapper logic, no stat()'ing in /dev, no reading of /proc/partitions,
> > no ioctl()'s, no hidden decisions, nothing. None of these actions is
> > acceptable to be done by the library itself, if udev is used. We need
> > pure mechanics, no policy. We also need an API that allows to specify
> > the size of the stream and the probing offset. And we don't want to
> > iterate over tags, need the filesystem version information, the raid
> > metadata probing, and the classification volume_id provides.
> 
>  Technical details :-)

What do you miss, these are all technical details. :) In simple words,
we need a completely policy-free, not try-to-be-smart in any sense set
of functions to identify a bytestream by magic bytes.

> > That means that we could replace the "low-level" part of libblkid with
> > volume_id code, and keep the current API of blkid, but offer some of the
> > low-level functionality for udev. Or we would implement the relevant
> > parts and probers in blkid, and add a new API to access the low-level
> > part directly.
> 
>  I don't see a problem to provide low-level and high-level interface in
>  same library. The low-level stuff (fsprobe code) is still same.

Yes, it would be the same.

>  Things like a cache are discussable -- for example resolve LABEL/UUID
>  on system with udev is faster by /dev/disk/by-*. I think a good
>  library has to be smart enough to found the fastest way how translate
>  LABEL/UUID to device name.

This is exactly what I mean and need to avoid. The library should not
try to be smart if not explicitly asked for. It should definitely not
"try to find something out". The caller is smart enough in this case.

>  But, it's too early to talk about details.
> 
> > Let me know what you think how go ahead with this, I'm all for doing
> > this sooner than later.
> 
>  Cool. I'd like to create libfsprobe as an independent project. Or is
>  there any advantage to merge everything to util-linux-ng? I don't
>  think so.

Hmm, only if you reaqlly don't want to pull it in util-linux, we could
have it as a separate tree. I still think util-linux is the best place,
because the most important user of it is mount/fsck. It's your call, I
would have no problem sending patches against util-linux. :)

Kay
