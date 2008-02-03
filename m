From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Fix ext4 bitops
Date: Sun, 3 Feb 2008 13:39:02 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802031336240.28712@anakin>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org>
 <20080201122257.9524c2bb.akpm@linux-foundation.org>
 <20080201210404.GA31271@wavehammer.waldi.eu.org> <20080203121238.GD18211@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bastian Blank <bastian@waldi.eu.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-s390@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/PPC Development <linuxppc-dev@ozlabs.org>,
	linux-ext4@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
	aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936272AbYBCMjZ@vger.kernel.org>
In-Reply-To: <20080203121238.GD18211@osiris.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 3 Feb 2008, Heiko Carstens wrote:
> On Fri, Feb 01, 2008 at 10:04:04PM +0100, Bastian Blank wrote:
> > On Fri, Feb 01, 2008 at 12:22:57PM -0800, Andrew Morton wrote:
> > > On Fri, 1 Feb 2008 21:02:08 +0100
> > > Bastian Blank <bastian@waldi.eu.org> wrote:
> > > 
> > > > Fix ext4 bitops.
> > > 
> > > This is incomplete.  Please tell us what was "fixed".
> > > 
> > > If it was a build error then please quote the compile error output in the
> > > changelog, as well as the usual description of what the problem is, and how
> > > it was fixed.
> > 
> > | fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
> > | fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'
> > 
> > The s390 specific bitops uses parts of the generic implementation.
> > Include the correct header.
> 
> That doesn't work:
> 
> fs/built-in.o: In function `ext4_mb_release_inode_pa':
> mballoc.c:(.text+0x95a8a): undefined reference to `generic_find_next_le_bit'
> fs/built-in.o: In function `ext4_mb_init_cache':
> mballoc.c:(.text+0x967ea): undefined reference to `generic_find_next_le_bit'
> 
> This still needs generic_find_next_le_bit which comes
> from lib/find_next_bit.c. That one doesn't get built on s390 since we
> don't set GENERIC_FIND_NEXT_BIT.
> Currently we have the lengthly patch below queued.

Similar issue on m68k. As Bastian also saw it on powerpc, I'm getting the
impression the ext4 people don't (compile) test on big endian machines?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
