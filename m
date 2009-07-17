From: Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
Subject: Re: [PATCH] debian: Remove uuid packages
Date: Fri, 17 Jul 2009 02:48:51 -0400
Message-ID: <20090717064851.GJ4207@webber.adilger.int>
References: <E1MRWBq-0000yy-0F@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
In-reply-to: <E1MRWBq-0000yy-0F-eEhpo0tUqaMrEHDPZeG1zdBPR1lH4CV8@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Jul 16, 2009  19:59 +0100, Scott James Remnant wrote:
> +Build-Depends: texi2html (>= 1.76), gettext, texinfo, dc, pkg-config, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powerpc ppc64 s390 sparc], debhelper (>= 7.0), libblkid-dev (>= 2.16), libuuid-dev (>= 2.16)

Same question as for libblkid-dev...  Ideally, even thought the package
version is 2.x, the ABI hasn't changed (AFAIK, that was a hard requirement)
so this should really still be called libuuid1 for compatibility.

> -Package: libuuid1

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
