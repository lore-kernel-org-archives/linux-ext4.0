From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 14:09:41 +0100
Message-ID: <478F5395.9040203@bull.net>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr> <1200509307.3985.8.camel@localhost.localdomain> <20080117064736.GA6749@skywalker> <478F234C.90807@bull.net> <20080117120752.GB24979@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59244 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYAQNIV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 08:08:21 -0500
In-Reply-To: <20080117120752.GB24979@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, Jan 17, 2008 at 10:43:40AM +0100, Valerie Clement wrote:
>> Aneesh Kumar K.V wrote:
>>> What about this  ? I guess we will overflow start =3D start << bsbi=
ts;
>>>
>> Hi Aneesh,
>> your patch below doesn't fix the issue, because as start_off is also=
 =20
>> loff_t, start_off =3D ac->ac_o_ex.fe_logical << bsbits  also overflo=
ws.
>>
>=20
> loff_t is 64 bits.
>=20
> typedef __kernel_loff_t         loff_t;
> typedef long long       __kernel_loff_t;
> typedef __u32 ext4_lblk_t;
> typedef unsigned long long ext4_fsblk_t
>=20
> start_off =3D ac->ac_o_ex.fe_logical << bsbits;
>=20
> In the above line what we are storing in start_off is the offset in b=
ytes.So it makes
> sense to use the type loff_t. It is neither logical block nor physica=
l block.

Oh yes, sorry, you're right. I read too quickly.

In fact, it's missing a cast :
   start_off =3D (loff_t) ac->ac_o_ex.fe_logical << bsbits;

With that change, the test is ok.

    Val=E9rie
