From: Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
Subject: Re: [PATCH] debian: Remove blkid packages
Date: Fri, 17 Jul 2009 02:43:28 -0400
Message-ID: <20090717064328.GI4207@webber.adilger.int>
References: <E1MRWBp-0000yr-Sq@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
In-reply-to: <E1MRWBp-0000yr-Sq-eEhpo0tUqaMrEHDPZeG1zdBPR1lH4CV8@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Jul 16, 2009  19:56 +0100, Scott James Remnant wrote:
> -Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0)
> +Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0), libblkid-dev (>= 2.16)

Should this really _require_ the util-linux (2.16) version of libblkid-dev?
Wouldn't an older e2fsprogs-based package be sufficient?

> -Package: libblkid-dev

Since the old package also provided "libblkid-dev" it doesn't necessarily
mean that package is obsolete.  If someone needs to install a new version
of e2fsprogs to fix a filesystem problem on an old system, they shouldn't
necessarily also have to install a new version of util-linux, which might
have all sorts of other dependencies, etc...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
