From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
	libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Sun, 28 Jun 2009 09:34:30 -0400
Message-ID: <20090628133430.GA3594@mit.edu>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu> <20090603085140.GA4060@nb.net.home> <1244021945.4120.4.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1244021945.4120.4.camel@quest>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Sorry for the delay; I've been incredibly busy.  I'm guessing you
never actually bothered to build and test the patch which you
submitted?

I tried building with --disable-libuuid, when it tried to compile
e2fsck, it crashed and burned.  The reason why was because LIBUUID
wasn't getting set properly:

% grep LIBUUID MCONFIG  | head -1
LIBUUID =  

And the reason for that is....

On Wed, Jun 03, 2009 at 10:39:05AM +0100, Scott James Remnant wrote:
> +AC_ARG_ENABLE([libuuid],
> +[  --disable-libuuid	  do not build private uuid library],
> +if test "$enableval" = "no"
> +then
> +	if test -z "$PKG_CONFIG"; then
> +		AC_MSG_ERROR([pkg-config not installed; please install it.])
> +	fi
> +
> +	AC_CHECK_LIB(uuid, uuid_generate,
> +		[LIBBLKID=`$PKG_CONFIG --libs uuid`;
                 ^^^^^^^^
> +		 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs uuid`],
                 ^^^^^^^^^^^^^^^
> +		[AC_MSG_ERROR([external uuid library not found])],
> +		[$LIBUUID])
> +	UUID_CMT=#
> +	AC_MSG_RESULT([Disabling private uuid library])

I'll have a corrected patch checked into e2fsprogs.

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
