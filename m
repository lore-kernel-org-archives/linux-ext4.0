From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Fri, 17 Jul 2009 11:02:07 -0400
Message-ID: <20090717150207.GA29705@mit.edu>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com> <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1247842479.4524.11.camel@quest>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 17, 2009 at 03:54:39PM +0100, Scott James Remnant wrote:
> > I'm not going to be applying these patches for quite some time.  I'd
> > much rather have packaging scripts that *know* they will be packaging
> > alongside util-linux-ng use --disable-libblkid, etc. so we don't break
> > things for folks who might need to build e2fsprogs for distributions
> > that are still using util-linux --- which at the moment still have the
> > vast majority of the installed base, and every so often people do
> > actually care about running updated filesystem utilities on an older
> > enterprise distribution.
>
> But you didn't accept those patches I sent either.

If I recall correctly the last set of patches unconditionally used
--disable-libblkid, and what I need is.....

> > ... at the minimum I'll want to make sure that the debian/rules file
> > packaged with e2fsprogs can build both for util-linux and
> > util-linux-ng for similar reasons, especially since Lamont hasn't
> > gotten back to us about potentially getting util-linux-ng packaged for
> > Debian yet.

So the patch ideal patch I'd like to see is one where you can toggle a
flag and debian/rules will either build for util-linux or
util-linux-ng.  If you've sent such a patch, my apologies for
overlooking it, but as I recall the only patch I got made the
unconditional changes to debian/rules.  When I commented on that you
said that you understood that was just a proof-of-concept patch, and
so I let things drop.

> I've done the packaging for him, it's just waiting on him to get back
> home to sponsor the uploads.

Are the .deb packages somewhere where I can examine them?

    	     	      		      	- Ted
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
