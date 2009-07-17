From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Fri, 17 Jul 2009 10:36:37 -0400
Message-ID: <20090717143637.GM8508@mit.edu>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E1MRWBp-0000yN-9a-eEhpo0tUqaMrEHDPZeG1zdBPR1lH4CV8@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 16, 2009 at 07:46:13PM +0100, Scott James Remnant wrote:
> Since util-linux-ng now builds libblkid by default, e2fsprogs
> should not do so.

I'm not going to be applying these patches for quite some time.  I'd
much rather have packaging scripts that *know* they will be packaging
alongside util-linux-ng use --disable-libblkid, etc. so we don't break
things for folks who might need to build e2fsprogs for distributions
that are still using util-linux --- which at the moment still have the
vast majority of the installed base, and every so often people do
actually care about running updated filesystem utilities on an older
enterprise distribution.

The at the minimum I'll want to make sure that the debian/rules file
packaged with e2fsprogs can build both for util-linux and
util-linux-ng for similar reasons, especially since Lamont hasn't
gotten back to us about potentially getting util-linux-ng packaged for
Debian yet.

							- Ted

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
