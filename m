From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 03:15:00 +0200
Message-ID: <200804220315.02147.rjw@sisk.pl>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D147C.90602@gmail.com> <20080421225452.GF9153@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	mingo@elte.hu, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: paulmck@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:38043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbYDVBON (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 21:14:13 -0400
In-Reply-To: <20080421225452.GF9153@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, 22 of April 2008, Paul E. McKenney wrote:
> On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
> > On 04/21/2008 11:58 PM, Jiri Slaby wrote:
> > >Leaving untouched.
> > >
> > >On 04/21/2008 11:18 PM, Jiri Slaby wrote:
> > >>On 04/21/2008 10:39 PM, David Miller wrote:
> > >>>From: Linus Torvalds <torvalds@linux-foundation.org>
> > >>>Date: Mon, 21 Apr 2008 09:54:07 -0700 (PDT)
> > >>>
> > >>>>What I find interesting is that at least for me, I have the SLAB 
> > >>>>bucket size for nf_conntrack_expect being 208 bytes. And the 
> > >>>>*biggest* merge by far after 2.6.25 so far has been networking (and 
> > >>>>conntrack in particular)
> > >>>>
> > >>>>Is that a smoking gun? Not necessarily. But it *is* intriguing. But 
> > >>>>there are other possible clashes (the 192-byte bucket has several 
> > >>>>different suspects, and not all of them are in networking).1
> > >>>
> > >>>I think you might be onto something here.
> > >>>
> > >>>The "mask" member of struct nf_conntrack_expect could be reasonably
> > >>>all 1's like the value reported in the crash that begins this
> > >>>thread.
> > >>>
> > >>>Do we know the offset within the object at which this all 1's
> > >>>value is found?
> > >>>
> > >>>My rough calculations show that on 32-bit that expect->mask member is
> > >>>at offset 56 and on 64-bit it should be at offset 72.  Does that
> > >>>match up to the offset of the filp or whatever bit being corrupted?
> > >>
> > >>dentry.d_name.name is 56 on 64-bit (my memcmp crashes)
> > >>dentry.d_hash.next is 24 (crashed at least 3 times here, rafael's one)
> > >>dentry.d_op is 136 (crash below)
> > >
> > >file.f_mapping is 176 (the another one from -rc8-mm2)
> > >
> > >the one at:
> > >http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/9008289.html 
> > >
> > >
> > >Having slub_debug enabled, tomorrow will be results, I guess...
> > 
> > Sorry, one more entry:
> > 
> > 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)
> > 00f0000000000000 dentry.d_hash.next (me, offset 24)
> > ffff81f02003f16c dentry.d_name.name (me, offset 56)
> >         memory ORed by 000000f000000000
> > fffff0002004c1b0 file.f_mapping (me, offset 176)
> >         memory hole, it was something like
> >         (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
> > ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
> >         -1, ~0ULL
> 
> Are these running with CONFIG_PREEMPT_RCU?  Grasping at straws, but
> there are a couple of patches that need to move from -rt to mainline,
> but mostly related to SELinux.  So if both PREEMPT_RCU and SELinux
> were in use, we might be missing "rcu-various-fixups.patch" from:
> 
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24.4-rt4-broken-out.tar.bz2

My kernel is only voluntarily preemptible (ie. CONFIG_PREEMPT_VOLUNTARY=y).

It is an SMP one, however.

Thanks,
Rafael
