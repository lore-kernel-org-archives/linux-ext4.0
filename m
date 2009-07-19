From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] debian: Remove uuid packages
Date: Sat, 18 Jul 2009 21:13:29 -0400
Message-ID: <20090719011329.GC2416@mit.edu>
References: <E1MRWBq-0000yy-0F@zelda.netsplit.com> <20090717064851.GJ4207@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090717064851.GJ4207-RIaA196FMs1uuQVovAj/GogTZbYi8/ss@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 17, 2009 at 02:48:51AM -0400, Andreas Dilger wrote:
> On Jul 16, 2009  19:59 +0100, Scott James Remnant wrote:
> > +Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0), libblkid-dev (>= 2.16), libuuid-dev (>= 2.16)
> 
> Same question as for libblkid-dev...  Ideally, even thought the package
> version is 2.x, the ABI hasn't changed (AFAIK, that was a hard requirement)
> so this should really still be called libuuid1 for compatibility.

The so version number for the package is still 1; so the packages
containing the binary shared libraries are libuuid1 and libblkid1.
What gets confusing is that version numbers for libblkid-dev,
libuuid-dev, libblkid1, and libuuid1 will be 2.16.x, not because of
any soversion number, but because that's the version number of
util-linux-ng.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
