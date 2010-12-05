From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 09:02:59 -0500
Message-ID: <20101205140259.GB4273@thunk.org>
References: <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
 <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
 <AANLkTi=OdYh0j4siMV1zzRQaRBEmi1nkjTcqHhM5tZH0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46498 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab0LEODM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Dec 2010 09:03:12 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=OdYh0j4siMV1zzRQaRBEmi1nkjTcqHhM5tZH0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 05, 2010 at 02:44:14PM +0100, Matt wrote:
> gcc version 4.5.1 (Gentoo Hardened 4.5.1-r1 p1.4, pie-0.4.5)

This is probably just me being paranoid, but it might be worth trying
using a gcc 4.4.x compiler and see if that makes any difference.
There have been some other gcc 4.5-caused probablems with the kernel,
and it might be a good idea to rule those out.  (I'm using gcc 4.4.3,
myself, and I'm deliberately avoiding the use of gcc 4.5 for now.)

       	     	       	       - Ted
