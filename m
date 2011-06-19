From: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Subject: Re: 2.6.39.1: Intel I340-T4: irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
Date: Sun, 19 Jun 2011 13:28:51 +0200
Message-ID: <s6nsjr6cb64.fsf@blaulicht.switch.brux>
References: <alpine.DEB.2.02.1106172106080.7672@p34.internal.lan>
	<4DFCD004.5090400@teksavvy.com>
	<C9702C53-7906-46F5-B635-3ED698A394C2@gmail.com>
	<s6nmxhft4wk.fsf@blaulicht.switch.brux>
	<5286EF78-DE5C-4B3F-ACE9-EFA2CBB535EF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from l1ms.rz.uni-kiel.de ([134.245.11.86]:59353 "EHLO
	l1ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1FSL26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jun 2011 07:28:58 -0400
Received: from amavis by l1ms.rz.uni-kiel.de with scanned-ok (Exim 4.74)
	(envelope-from <boettcher@physik.uni-kiel.de>)
	id 1QYGBV-0006hy-6F
	for linux-ext4@vger.kernel.org; Sun, 19 Jun 2011 13:28:57 +0200
In-Reply-To: <5286EF78-DE5C-4B3F-ACE9-EFA2CBB535EF@dilger.ca> (Andreas
	Dilger's message of "Sat, 18 Jun 2011 13:44:28 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@dilger.ca> writes:

> On 2011-06-18, at 11:39 AM, Stephan Boettcher wrote:
>> Andreas Dilger <adilger@dilger.ca> writes:
>>> There are a few places in the ext4 mount that are doing large
>>> allocations. In some places they fall back to vmalloc, so they shou=
ld
>>> really be done with GFP_NOWARN.
>>>=20
>>> A few places don't yet fall back to vmalloc(), which is a problem
>>> with fragmented memory or very large filesystems. We were trying to
>>> test a 192TB ext4 filesystem, but were unable to mount it without
>>> patching the kernel.
>>=20
>> :-O ...  my puny 20TB ext4 filesystem did not do something like
>> this, yet.
>
> What sort of experience do you have with using a filesystem > 20TB?
> I don't think there are many users out there yet that are doing this
> today, so it would be great if you could share some data with us.

I will, as soon as something interesting shows up.  Currently it is
offline, I need to buy some hardware for the frontend.

The setup is nfs-md-nbd-md-sata, RAID5=C2=B2, 3*(6*2TB), mostly for bac=
kups.  The
aim is to keep some old solid 32-bit servers usefull for a little longe=
r.

Three 32-bit servers each provide a 10TB nbd to the frontend, which
must be 64-bit.  The frontend, that run the outer md-RAID5 on three nbd
was an Atom525, which I had to return to it's original duties last week=
=2E

So far I filled it about 25% with backups via rsync. =20

I did not observe any problems with the filesystem.  I did run several
fsck, which were surprisingly fast.  The problem I had were of the kind
that I could not login to any of the servers while they were busy
rebuilding the RAID.  This will get solved with a little more networkin=
g
gear.

As soon as I get new frontend hardware, I can run some tests, if
somebody tells me what and how to do it.  The data that is currently on
there is expendable.  The tests shall not target performance of any kin=
d,
for obvious reasons.

> So far, we've only been doing testing and benchmarking (mke2fs, e2fsc=
k
> times, IO and metadata load tests, etc) and I don't know that all of
> the "real world" corner cases have been tested yet.

Well, all the real world corner cases will be well out of my reach with
this setup.

--=20
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
