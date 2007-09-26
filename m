From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 21:07:51 +0200
Message-ID: <20070926190751.GA2835@petra.dvoda.cz>
References: <20070925153735.GA26693@infradead.org> <20070926105946.GB429@thunk.org> <20070926120533.GA15894@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070926120533.GA15894-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 26, 2007 at 01:05:33PM +0100, Christoph Hellwig wrote:
> > BTW, I don't like this syntax in the fstab file AT ALL, but it is in
> > use in the wild by at least some Fedora users, and it's not documented
> > in the fstab man page.  I'd suggest using a filesystem type of bind,
> > rather than ext3, as the officially "blessed" way of specifying it in
> > fstab, but it badly needs to be documented in the fstab and/or mount
> > man pages.  The above patch should probably get included, though, and
> > backwards compatibility for allowing "bind" to be specified in the
> > mount options, and with a warning message that the specifying "bind"
> > in the options field has been deprecated.
> 
> The syntax is indeed horrible.  Is it supported by upstream util-linux?

 Sure, it's supported.

 mount(8) supports the "bind" as standard mount option (since
 util-linux 2.10). There is not difference between options from fstab
 and command line.

> I've started looking into this, and I think at least for the detect
> which filesystem we have part libblkid is complete overkill.  libvolume_id
> has a really nice lowlevel API for that that is much more suitable.

 It depends.. for example I think that call blindly all probing
 functions is overkill. The libblkid is firstly trying to recognize FS
 type by magic string.

> So if it was up to me I'd do the following:
> 
>  - move libvolume_id out of udev
>  - make mount/fsck use libvolume_id unconditionally for detecting the
>    filesystem type.  There's absolute no reason to use anything in

    unconditionally ... absolute no reason...

 Too strong words, especially when there are distributions that depend
 on some features from libblkid (for example device-mapper support).

>    libblkid for this, and caching the result doesn't help us at all
>    as we're going to touch the disk anyway as part of the mount/fsck.

 I agree that the cache should be optional, rather than mandatory. For
 example for FS type detection is it overkill, but for LABEL/UUID
 translation is it good thing (especially on systems without
 /dev/disk/by-*).

> Another note on moving the libraries into util-linux vs a standalone package:
> At least in xfs land people do upgrade xfsprogs frequently and sometimes
> independent os the distro because new features get added quite a bit, including
> new filesystem features that require support.  Having to upgrade util-linux
> for that is not very helpful.  So I'm not so sure about moving this to
> util-linux

 I think we can always change this concept in dependence on feedback
 from distributors/developers.

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
