From: Mike Snitzer <snitzer@redhat.com>
Subject: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier
 support is effective)
Date: Wed, 1 Dec 2010 16:23:10 -0500
Message-ID: <20101201212310.GA15648@redhat.com>
References: <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com>
 <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>,
	Chris Mason <chris.mason@oracle.com>, htejun@gmail.com,
	linux-ext4@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>, Matt <jackdachef@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0LAVXb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Dec 2010 16:23:31 -0500
Content-Disposition: inline
In-Reply-To: <4CF6B3E8.2000406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 01 2010 at  3:45pm -0500,
Milan Broz <mbroz@redhat.com> wrote:

> 
> On 12/01/2010 08:34 PM, Jon Nelson wrote:
> > Perhaps this is useful: for myself, I found that when I started using
> > 2.6.37rc3 that postgresql starting having a *lot* of problems with
> > corruption. Specifically, I noted zeroed pages, corruption in headers,
> > all sorts of stuff on /newly created/ tables, especially during index
> > creation. I had a fairly high hit rate of failure. I backed off to
> > 2.6.34.7 and have *zero* problems (in fact, prior to 2.6.37rc3, I had
> > never had a corruption issue with postgresql). I ran on 2.6.36 for a
> > few weeks as well, without issue.
> > 
> > I am using kcrypt with lvm on top of that, and ext4 on top of that.
> 
> With unpatched dmcrypt (IOW with Linus' git)? Then it must be ext4 or
> dm-core problem because there were no patches for dm-crypt...

Matt and Jon,

If you'd be up to it: could you try testing your dm-crypt+ext4
corruption reproducers against the following two 2.6.37-rc commits:

1) 1de3e3df917459422cb2aecac440febc8879d410
then
2) bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc

Then, depending on results of no corruption for those commits, bonus
points for testing the same commits but with Andi and Milan's latest
dm-crypt cpu scalability patch applied too:
https://patchwork.kernel.org/patch/365542/

Thanks!
Mike
