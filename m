From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 5 Dec 2010 08:24:32 -0500
Message-ID: <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com> <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com> <20101205100954.GA6564@fritha.org> <4CFB679D.5030900@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Heinz Diehl <htd@fritha.org>, Jon Nelson <jnelson@jamponi.net>,
	htejun@gmail.com, Matt <jackdachef@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:42007 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab0LENYm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Dec 2010 08:24:42 -0500
In-Reply-To: <4CFB679D.5030900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Dec 5, 2010, at 5:21 AM, Milan Broz wrote:
> 
> Which kernel? 2.6.37-rc?
> 
> Anyone seen this with 2.6.36 and the same dmcrypt patch?
> (All info I had is that is is stable with here.)
> 
> It still seems to like dmcrypt with its parallel processing is just
> trigger to another bug in 37-rc.

I've been using a kernel which is between 2.6.37-rc2 and -rc3 with a LUKS / dm-crypt / LVM / ext4 setup for my primary file systems, and I haven't observed any corruption for the last two weeks or so.   It's on my todo list to upgrade to top of Linus's tree, but perhaps this is a useful data point.

As another thought, what version of GCC are people using who are having difficulty?   Could this perhaps be a compiler-related issue?

-- Ted

