From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Date: Sun, 05 Dec 2010 22:42:07 +0100
Message-ID: <4CFC072F.8090302@redhat.com>
References: <4CF692D1.1010906@redhat.com>	<AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>	<4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>	<AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>	<20101204193828.GB13871@redhat.com>	<AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>	<20101205100954.GA6564@fritha.org> <4CFB679D.5030900@redhat.com>	<1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu> <20101205202855.GA7668@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@MIT.EDU>,
	Jon Nelson <jnelson@jamponi.net>, htejun@gmail.com,
	Mike Snitzer <snitzer@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Matt <jackdachef@gmail.com>, htd <htd@fancy-poultry.org>,
	Heinz Diehl <htd@fritha.org>, linux-ext4@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0LEVmc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Dec 2010 16:42:32 -0500
In-Reply-To: <20101205202855.GA7668@basil.fritz.box>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/05/2010 09:28 PM, Andi Kleen wrote:
>> I've been using a kernel which is between 2.6.37-rc2 and -rc3 with
>> a LUKS / dm-crypt / LVM / ext4 setup for my primary file systems,
>> and I haven't observed any corruption for the last two weeks or so.
>> It's on my todo list to upgrade to top of Linus's tree, but perhaps
>> this is a useful data point.
> 
> The reported corruptions are with a .37 forward port someone did of
> my parallel kcryptd patch.  The 2.6.36 (and earlier) versions are
> rock solid with many users.

ok, to not confuse which patch version people are testing,
let's use the version in Alasdair's DM repo now (upstream queue):
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-scale-to-multiple-CPUs.patch
(it should be the same as v5/v6 here on dm-devel -
Andi's patch + my changes for device stacking deadlock)

The same patch (just with minor define fix) is reported rock solid for 2.6.36.

Milan
