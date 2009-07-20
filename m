From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Mon, 20 Jul 2009 10:23:37 -0400
Message-ID: <20090720142337.GH2416@mit.edu>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com> <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest> <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest> <20090719115617.GF2416@mit.edu> <20090719212714.GA6886@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090719212714.GA6886-sHeGUpI7y9L/9pzu0YdTqQ@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 19, 2009 at 11:27:14PM +0200, Karel Zak wrote:
> 
> On Sun, Jul 19, 2009 at 07:56:17AM -0400, Theodore Tso wrote:
> > Also, apparently no once noticed until now, but there's a bug in the
> > util-linux-ng's uuid.sym file.  The uuid_pack and uuid_unpack symbols
> > are missing, because someone forgot to include them in the uuid.sym
> > file.
> 
>  is it really bug? Why do you want to export symbols that are not part
>  of the library API? 

You're right; I took a closer look at it, and they aren't part of the
library API.

>  Unfortunately, it's not possible to combine versioned symbols with
>  anonymous (without version) symbols. It means after first change to
>  the library ABI we will need to introduce UUID_1.0 for old symbols.

Yes, but I would have preferred to do so on a per symbol basis.  And
the UUID library isn't one that's likely to change in the future.

> > Argh, util-linux-ng 2.16 has already been released; is it too late to
> > undo this change?
> 
>  I think yes, it's too late.
> 
>  A new version (2.16.1) without UUID_1.0 will require mass rebuild in
>  all distributions/systems where are libuuid applications with ABI
>  versioning. IMHO this is much more painful that impossibility to
>  downgrade to the old libuuid (from e2fsprogs).

Sigh, you're probably right.

>  Maybe we can add --disable-{libuuid,libblkid}-versioning for people
>  who need to bypass the default behaviour.

There are some commercial programs that might use libuuid --- minor
ones, like SAP R/3.  So they might want to create programs that work
on both RHEL 5 and RHEL 6.  The only way I can think of doing this is
to build the link libraries without the map file, and the shared
library with the map file.

	    	      	      	     	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
