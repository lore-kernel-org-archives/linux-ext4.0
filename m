From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Mon, 21 Apr 2008 20:56:47 +0200
Message-ID: <20080421185647.GA32598@elte.hu>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <20080421131741.GI9554@elte.hu> <200804211535.21694.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:47005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758794AbYDUS5I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 14:57:08 -0400
Content-Disposition: inline
In-Reply-To: <200804211535.21694.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday, 21 of April 2008, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > I've just got the following traces from 2.6.25-git2 on HP nx6325 
> > > (64-bit). I think they are related to the hang I described yesterday:
> > 
> > > [12844.112673]  [<ffffffff8029e236>] do_lookup+0x2c/0x1b2
> > > [12844.112683]  [<ffffffff802a04b4>] __link_path_walk+0x8e6/0xdbd
> > > [12844.112707]  [<ffffffffa004deb4>] ? :ext3:ext3_xattr_get_acl_default+0x18/0x1a
> > > [12844.112714]  [<ffffffff802b0869>] ? generic_getxattr+0x4e/0x5c
> > 
> > so you've got ext3. Nothing changed in the VFS or in ext3 in -git yet.
> > 
> > the instruction pattern:
> > 
> > Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 
> > 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 
> > 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff
> >                            ========
> > 
> > shows that you've got "prefetchnta (%esi)" indirect:
> > 
> >    0f 18 00                prefetcht0 (%eax)
> > 
> > so the prefetch instructions are patched in, neither the compiler nor 
> > the CPU should ignore them.
> 
> Well, I don't really know what that means ...
> 
> Besides, that's 64-bit code, but I guess that doesn't matter here.

correct, for 64-bit code that's prefetcht0 (%rax) - a non-destructive 
'prefetch stuff from there into the cache' x86 instruction. So real 
prefetches are done so i'd exclude any true SMP related barrier race. 
(not that it's likely on x86 hardware anyway - memory barriers usually 
only matter on Alpha and similar weakly-ordered architectures.)

	Ingo
