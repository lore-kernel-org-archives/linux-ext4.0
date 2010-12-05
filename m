From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 16:15:02 -0500
Message-ID: <20101205211502.GA20713@redhat.com>
References: <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
 <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
 <20101205202855.GA7668@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>,
	device-mapper development <dm-devel@redhat.com>,
	Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0LEVPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Dec 2010 16:15:22 -0500
Content-Disposition: inline
In-Reply-To: <20101205202855.GA7668@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 05 2010 at  3:28pm -0500,
Andi Kleen <andi@firstfloor.org> wrote:

> > As another thought, what version of GCC are people using who are having difficulty?   Could this perhaps be a compiler-related issue?
> 
> A compiler problem seems very unlikely here.
> 
> What may be an useful experiment would be to test 2.6.37-rc + ext4 over
> device mapper, but not dmcrypt. If that fails too then it's likely
> some generic device mapper problem.

That would only prove its not dm-crypt; it would not absolve a non-DM
2.6.37-rc change at all.

Leveraging the fact that 2.6.36 + parallel dm-crypt is reportedly very
solid: maybe these would be more interesting (each would keep the latest
parallel dm-crypt patch overlayed for all tests):

1) Test 2.6.37-rc prior to all flush+fua changes (only changes DM saw
   for 2.6.37-rc so far).

2) Back out all ext4 changes that were merged for 2.6.37-rc
   - though Heinz is using XFS exclussively and still reported
     corruption

3) A full git bisect of good=v2.6.36 bad=v2.6.37-rc4 would be the most
   interesting.  Albeit much more tedious.

Mike
