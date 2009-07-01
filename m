From: Matthew Burgess <matthew-Ugr1wgFcK0zneqvOfBTmdWD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:libuuid (Re:
 blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 15:04:43 -0600
Message-ID: <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org>
References: <20090628133430.GA3594@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090628133430.GA3594-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 28 Jun 2009 09:34:30 -0400, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org> wrote:

> I'll have a corrected patch checked into e2fsprogs.

Hi,

I get the following output when trying to compile e2fsprogs-1.41.7
against util-linux-ng-2.16-rc1's installed versions of libuuid &
libblkid:

	CC ../../e2fsck/profile.c
	CC prof_err.c
make[3]: *** No rule to make target `-L/tools/lib', needed by `e2fsck'.  Stop.
make[3]: Leaving directory `/mnt/lfs/sources/e2fsprogs-1.41.7/build/e2fsck'
make[2]: *** [all-progs-recursive] Error 1
make[2]: Leaving directory `/mnt/lfs/sources/e2fsprogs-1.41.7/build'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/mnt/lfs/sources/e2fsprogs-1.41.7/build'

This was after doing:

../configure --prefix=/tools --disable-libblkid --disable-libuuid

This appears to stem from the following bits of the Makefile:

e2fsck: $(OBJS)  $(DEPLIBS)
DEPLIBS= $(LIBEXT2FS) $(LIBCOM_ERR) $(DEPLIBBLKID) $(DEPLIBUUID) $(DEPLIBE2P)
DEPLIBBLKID =   $(LIBUUID)
LIBUUID = -L/tools/lib -luuid

So, DEPLIBBLKID appears to be getting set even if the building of libuuid &
libblkid has been disabled.  Should DEPLIBBLKID & DEPLIBUUID even be included
in DEPLIBS in that circumstance?

Thanks,

Matt.

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
