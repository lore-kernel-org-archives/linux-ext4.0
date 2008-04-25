From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Fri, 25 Apr 2008 00:45:23 -0700 (PDT)
Message-ID: <20080425.004523.146850490.davem@davemloft.net>
References: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>
	<20080424.185757.254044977.davem@davemloft.net>
	<48118B18.5020008@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	mingo@elte.hu, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
To: jirislaby@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48982
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753429AbYDYHpX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 03:45:23 -0400
In-Reply-To: <48118B18.5020008@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>
Date: Fri, 25 Apr 2008 09:41:12 +0200

> Added 3 80211 experts.
> 
> On 04/25/2008 03:57 AM, David Miller wrote:
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > Date: Thu, 24 Apr 2008 18:48:32 -0700 (PDT)
> > 
> >> But that 0xf0 definitely has shown up before. It's not the *only* 
> >> corruption, but it's definitely a very interesting pattern. And the other 
> >> ones that didn't show the 0xf0 pattern could obviously be due to pointers 
> >> that were corrupted by 0xf0 in low bytes, so it _may_ be the source of the 
> >> other corruptions too that didn't have an obvious 0xf0 directly in them.
> > 
> > Ok.
> > 
> > Do we know of any pattern of the wireless device type in use?
> > If there is a pattern to that, it would be a huge clue.
> > 
> > And if it is predominantly one particular wireless device type, we
> > should be able to come up with a patch to test.
> 
> Johannes, Michael, Jiri? Someone writes to freed memory patterns 0xf0 (not 
> aligned to anything, addressed per byte), one of suspects is mac80211, don't you 
> know that pattern from anywhere?

I notice Jiri, in your hardware list, you have an ath5k Atheros AR5212 chip
in there.

I took a look at the resume code for ath5k but nothing really suspicious
there except:

	err = pci_enable_device(pdev);
	if (err)
		return err;

	pci_restore_state(pdev);

Shouldn't we restore state before we turn the chip back on and thus
potentially let it start DMA'ing all over the place?
