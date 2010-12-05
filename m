From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 21:28:55 +0100
Message-ID: <20101205202855.GA7668@basil.fritz.box>
References: <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
 <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: device-mapper development <dm-devel@redhat.com>,
	Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Matt <jackdachef@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0LEU3A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Dec 2010 15:29:00 -0500
Content-Disposition: inline
In-Reply-To: <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I've been using a kernel which is between 2.6.37-rc2 and -rc3 with a LUKS / dm-crypt / LVM / ext4 setup for my primary file systems, and I haven't observed any corruption for the last two weeks or so.   It's on my todo list to upgrade to top of Linus's tree, but perhaps this is a useful data point.

The reported corruptions are with a .37 forward port someone did of my parallel 
kcryptd patch.  The 2.6.36 (and earlier) versions are rock solid with many users.

The classic dmcrypt is single threaded and very slow.

> As another thought, what version of GCC are people using who are having difficulty?   Could this perhaps be a compiler-related issue?

A compiler problem seems very unlikely here.

What may be an useful experiment would be to test 2.6.37-rc + ext4 over
device mapper, but not dmcrypt. If that fails too then it's likely
some generic device mapper problem.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
