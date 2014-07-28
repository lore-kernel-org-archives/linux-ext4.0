From: "Vicentiu Neagoe" <vicentiu.neagoe@ni.com>
Subject: Re: resilience against power loss
Date: Mon, 28 Jul 2014 18:23:11 +0300
Message-ID: <53D66ADF.14170.351043D9@vicentiu.neagoe.ni.com>
References: <53CE9282.11182.166B0034@vicentiu.neagoe.ni.com>, <alpine.LFD.2.00.1407281044200.2077@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from skprod3.natinst.com ([130.164.80.24]:57882 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbaG1PXP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 11:23:15 -0400
Received: from us-aus-mgwout1.amer.corp.natinst.com (nb-chan1-1338.natinst.com [130.164.19.134])
	by us-aus-skprod3.natinst.com (8.14.5/8.14.5) with ESMTP id s6SFNCdj004521
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 10:23:13 -0500
In-reply-to: <alpine.LFD.2.00.1407281044200.2077@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 28 Jul 2014 at 10:48, Luk=E1s Czerner wrote:

> On Tue, 22 Jul 2014, vicentiu.neagoe@ni.com wrote:
>=20
> > Date: Tue, 22 Jul 2014 19:34:10 +0300
> > From: vicentiu.neagoe@ni.com
> > To: linux-ext4@vger.kernel.org
> > Subject: resilience against power loss
> >=20
> > Hello,
> >=20
> > I'm trying to configure ext4 to prevent data corruption in case of =
a=20
> > power loss.
> >=20
> > I test by doing a cold reset right after writing to a file.
> > I tried the nodelalloc option, but the file still becomes corrupted=
=20
> > with trailing garbage.
> >=20
> > Using ext3, I either get the old version of the file, or the new=20
> > version, and there is no corruption.
> >=20
> > Does nodelalloc not guarantee data integrity?
> >=20
> > Are there any other options that provide complete resilience agains=
t=20
> > power loss?
>=20
> Well, that would be fsync. It'll make sure that your data actually re=
ach
> disk and that the disk actually write it from the cache to platters.

I don't have control over how the applications were written, yet I=20
need the system to not corrupt or lose data in case of a power loss.

I have the partition mounted with the sync option but the issue still=20
reproduces.
Are there no options on ext4 to provide the same data integrity as=20
data=3Dordered on ext3? I also tested with Btrfs and there is no data=20
corruption on a power loss.

Vicentiu

> -Lukas
>=20
> >=20
> > thanks
> >=20
> > Vicentiu
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
