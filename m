From: =?ISO-8859-1?Q?C=E9dric_Villemain?=
	<cedric.villemain.debian@gmail.com>
Subject: Re: 3.2 and 3.1 filesystem scalability measurements
Date: Mon, 30 Jan 2012 16:36:12 +0100
Message-ID: <CAF6yO=05-dHmYGkRTwtsJkf886Vry3e5ZP+anemseXNB3mgTNA@mail.gmail.com>
References: <4F261807.2060108@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65374 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2A3Pgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 10:36:33 -0500
In-Reply-To: <4F261807.2060108@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le 30 janvier 2012 05:09, Eric Whitney <eric.whitney@hp.com> a =E9crit =
:
> I've posted the results of some 3.2 and 3.1 ext4 scalability measurem=
ents
> and comparisons on a 48 core x86-64 server at:
>
> http://free.linux.hp.com/~enw/ext4/3.2
>
> This includes throughput and CPU efficiency graphs for five simple
> workloads, the raw data for same, plus lockstats on ext4 filesystems =
with
> and without journals. =A0The data have been useful in improving ext4
> scalability as a function of core and thread count in the past.
>
> For reference, ext3, xfs, and btrfs data are also included.

interesting to have all of them, yes.

>
> The most notable improvement in 3.2 is a big scalability gain for jou=
rnaled
> ext4 when running the large_file_creates workload. =A0This bisects cl=
eanly to
> Wu Fengguang's IO-less balance_dirty_pages() patch which was included=
 in the
> 3.2 merge window.
>
> (Please note that the test system's hardware and firmware configurati=
on has
> changed since my last posting, so this data set cannot be directly co=
mpared
> with my older sets.)
>
> Thanks,
> Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
C=E9dric Villemain +33 (0)6 20 30 22 52
http://2ndQuadrant.fr/
PostgreSQL: Support 24x7 - D=E9veloppement, Expertise et Formation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
