From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] ext4-locality-groups patch
Date: Wed, 13 Dec 2006 15:37:12 +0100
Message-ID: <45801018.1090001@bull.net>
References: <m3vekwtqnp.fsf@bzzz.home.net> <45800965.2080005@bull.net> <m3wt4vzxje.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42411 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831AbWLMOjT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 09:39:19 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3wt4vzxje.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
>>>>>> Valerie Clement (VC) writes:
>=20
>  VC> Hi Alex,
>  VC> I did the following test:
>  VC> # mkfs /dev/sdc1
>  VC> # mount -t ext4dev -o extents,mballoc,delalloc /dev/sdc1 /test
>  VC> # dumpe2fs -h /dev/sdc1
>  VC> # cp linux.tar /test
>  VC> # tar xf /test/linux.tar
>  VC> # dumpe2fs -h /dev/sdc1
>=20
>  VC> The "Free blocks" and "Free inodes" counters in the dumpe2fs out=
put
>  VC> did not change after running the cp and tar commands.
>=20
> sync should help, I think.

No, I've just tried, it does not change anything.
   Val=E9rie

>=20
>  VC> I think it misses a call to ext4_commit_super() at the end of th=
e
>  VC> ext4_lg_sync_inodes function.
>  VC> Am I right ?
>=20
> what for? allocation was delayed, no blocks were allocated.
>=20
> thanks, Alex
>=20
