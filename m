From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
	libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 2 Jul 2009 12:24:18 -0400
Message-ID: <20090702162418.GA29134@mit.edu>
References: <200905311113.23004.arvidjaar@mail.ru> <ac3eb2510907020549g138c5dd2y3caa8eeba782c3ac@mail.gmail.com> <20090702142515.GA29429@mit.edu> <200907021151.10268.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200907021151.10268.vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 02, 2009 at 11:51:08AM -0400, Mike Frysinger wrote:
> > If someone can point me at an autoconf test that determines whether or
> > not we're using gmake, I could even set up something which sucks in a
> > Makefile fragment that enhances what we can do for developers who are
> > using GNU make.  (i.e., if you're using GNU make, "make V=1" will
> > DTRT, but if you're using a Solaris or BSD make, you'll have to settle
> > for "configure --enable-verbose-makecmds")
> 
> two methods:
>  - http://autoconf-archive.cryp.to/check_gnu_make.html

Very cool, that was just what I was looking for.  Thanks!!

     	   	    	      	    	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
