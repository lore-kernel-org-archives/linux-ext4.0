From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option
	(Was:libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 22:26:52 -0400
Message-ID: <20090702022652.GI17054@mit.edu>
References: <20090628133430.GA3594@mit.edu> <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org> <20090701212844.GC17054@mit.edu> <200907011742.28028.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Burgess <matthew-Ugr1wgFcK0zneqvOfBTmdWD2FQJk+8+b@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200907011742.28028.vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 01, 2009 at 05:42:26PM -0400, Mike Frysinger wrote:
> that's because -lfoo is an extension that GNU make supports (albeit, kind of a 
> lame one).  com_err has a similar problem:
> http://sourceforge.net/tracker/?func=detail&aid=2813809&group_id=2406&atid=302406

I've checked in a fix for this in the maint branch of e2fsprogs.

     	     	      	       	      	    - Ted



--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
