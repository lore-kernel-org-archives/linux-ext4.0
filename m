Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221F9C282CE
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 13:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE5C218FD
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 13:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="TR/G4q7M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfDXNzI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:55:08 -0400
Received: from mout.gmx.net ([212.227.15.19]:57535 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfDXNzH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 09:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556114092;
        bh=knJ5L/YTRGVH6dCxwAxMFX7WFi67EQWi68juvlfnGyE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=TR/G4q7M4xOv79DBcDv7cCWqPLdg9cp6QxAGIQZP7OqslDfif1n97WfcnnFql0Ee9
         KSGGuBJ9Awhl64lX40Nn4qUnPwKtNLaqGNgoZMAPNS93SSYyKeKgzwC8F3O0+FwK7r
         eMd35x3Vv2pGnkksF8kxpg140/KXI/u90zD22/EA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MUYnD-1hBDUO0fJb-00RKdY; Wed, 24
 Apr 2019 15:54:52 +0200
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
To:     James Morse <james.morse@arm.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
 <20190421132840.GK7751@bombadil.infradead.org>
 <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
 <98fad1eb-b033-3c31-9100-bad672b4cfe0@arm.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <64d8dcca-6f58-c2bc-c62e-f6e36fbfa6d5@gmx.com>
Date:   Wed, 24 Apr 2019 21:54:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <98fad1eb-b033-3c31-9100-bad672b4cfe0@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Ogrk0EEy4DCWLZQicDrILMPI9qf87sjn"
X-Provags-ID: V03:K1:MUZmZXidHA45uQ7yvXPZGggBJ46Ga2XfvV+2/2iCM6nL7Xi5AHP
 AST08MMso9cLVubipOm5mwgEY0pz6L58AKg2MC9h12DD94Q3xDKx23Snb5mUAUw6mYLFE+h
 ZfxSasxki0pL1wiZWxvbcgv1yZnd8tXx5eNhiD7QXyepiERGGYNH7d0E627sVGf/Ndokq6J
 gT/HL/6cg9Zh6QAQQPcOA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sjGq5STo4hs=:iLU7W3NPcnt/+6ExnLq3lk
 HJwT38MgnfHg6kC2vh+kqb17BcpsnIocGJhuGKd0/ME5L/DWswnzeS6jSHbfAphzoqJfFc0+r
 G2Z4Gyrd3DCE/ng5FOuXB8AJxlC/khkizgZLRaVa/IcTTbw7Z6QME2J75Ua9UUZzWMR3wTbUa
 EaSRhgzs+L/i5pKLlf2hn06U91NJJNKQ9E+Zv0qRuAnrzQPSBOo6AoFKHx9nHWgSeXM0yrDim
 zyzvM4AMmU5Z3HoiHw5oMd8jhrBy0cKz31cgyK+zW81HevGkI31Sa0TWol88iIseKu4erimej
 pdPIxYBGS51oqFVU3DAP/p+bK7lMGEMAg4ATOWJtaMfD3obDbVN966gpX6KX5mrd//rfsF7wg
 NBSq5K9L9i0V48VyTCNVU7CAWO3LCYmOI6Ah6EC9m6U5QZcx4/2pO1H+V4CDQJ+y1JrH+AHbl
 2MWZwlRBY4oCWQshX2klPQ+TS/aMDVcAKXTxEQmjq6yH/WUAHvq40ohO1l+kH/6I0jCyBuMn6
 Qh3TL7nEDnHpvh3em0dVXOQ7Uv0LK8u+6ZeHK1fgmusyMf+d/07KJPtqeKUSBmLdr0Vltqmui
 dOQc74uUiocuiGrCSB8b8UBP/k6kWwD+s+ObFe+cIKc7jOaBANp1xYdJlZBCZzv/m7qXp7kc8
 X+AsjrmkUuowOAXFDfRpCXvWKAeATiY2RwGdyHhJMCwGF/CmJFFLTXOdd3ZJtd3Ns/gdtp0Bx
 sMJGLbVQK9vXMzRfKgSU4HERelAQjpuj893uDzz5iJFgpNi1XDkfSky9B+ktVQSvhkRHhRm4u
 8j1qMQCHzabYPkQG/6ZlEnx+L86Bb7pOkAbr64oZB3JzcYZ/Qic6f/wjFCX0xys3uxyr3/Lki
 CfPR9B5vKU6zGy712GxGcYkvkqSKNh+gUWCeaaxk++dAdfQKE/6CBK2KADMphM
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Ogrk0EEy4DCWLZQicDrILMPI9qf87sjn
Content-Type: multipart/mixed; boundary="tPIc3Bo2gFtycTKrm4Q6PWjNuemD5nGOT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: James Morse <james.morse@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 Ext4 <linux-ext4@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Message-ID: <64d8dcca-6f58-c2bc-c62e-f6e36fbfa6d5@gmx.com>
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
 <20190421132840.GK7751@bombadil.infradead.org>
 <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
 <98fad1eb-b033-3c31-9100-bad672b4cfe0@arm.com>
In-Reply-To: <98fad1eb-b033-3c31-9100-bad672b4cfe0@arm.com>

--tPIc3Bo2gFtycTKrm4Q6PWjNuemD5nGOT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/24 =E4=B8=8B=E5=8D=889:50, James Morse wrote:
> Hi Qu,
>=20
> On 22/04/2019 02:14, Qu Wenruo wrote:
>> On 2019/4/21 =E4=B8=8B=E5=8D=889:28, Matthew Wilcox wrote:
>>> On Sun, Apr 21, 2019 at 05:12:50PM +0800, Qu Wenruo wrote:
>>>> On 2019/4/21 =E4=B8=8B=E5=8D=884:20, Qu Wenruo wrote:
>>>>> Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.
>>>>
>>>> Well, also hit the same one in v5.0.8 kernel.
>>>>
>>>> Exact the same backtrace.
>>>>
>>>> Really not sure which part is to blame, ARM or ext4?
>>>
>>> You probably have faulty hardware:
>=20
>> I tried memtester, and kernel also crashed.
>>
>> Maybe it's really faulty memory or I'm using wrong memory speed.
>=20
> As another option: there may be no memory at this physical address.
> If your board only has 1G of memory, but the bootloader/DT is reporting=
 2G, you could see
> SError like this (assuming this is the first access to that page).

Device tree is correct and it matches.

The reason is the memory controller is not initialized correctly by Uboot=
=2E

After reverting Uboot from upstream one (with basic support) to legacy
one, no such problem anymore.

To my surprise, it's UBoot to initialize the memory controller, not the
rockchip idbloader nor the trusted image.

>=20
> SError can be a fatal interrupt from the hardware, its also how the CPU=
 tells us about
> 'asynchronous external abort'. In this case it could be an attempt to a=
ccess a physical
> address where nothing exists.

So it's the equvilent of X86 machine check exception?

Anyway, at least I learned something about the new ARM world.

Thanks,
Qu

>=20
>=20
> Thanks,
>=20
> James
>=20


--tPIc3Bo2gFtycTKrm4Q6PWjNuemD5nGOT--

--2Ogrk0EEy4DCWLZQicDrILMPI9qf87sjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzAaqUACgkQwj2R86El
/qglpAgAnaQb8b21gAbYudJcG+Aoi/SxMqrLI+xSrTRstlVGewbol9TmY35jVgjo
AMYzZ8I4jf6NGz8v4mTHUF/LoJUk+Ype/MgsZMvL9f8dueWjhqtykOh2DZYKh3cz
Gje7UxHmy2cncZAFv7mVza/CJLEhiVOljbPpHm+W7lMZx3KSouEF9OGdLKnNQESe
gM8iJJFEX+TexYQtHDR+6gq2hcTwxLEWP3n9cugB1+F0hBnlXX/pcBhgPAd1FoYr
qBNmJBMaikehMupbA5jbA11xhkSHmeDlLtdB6XOHYDrg9gCKDuxXeaopxXi+uVzp
1tEAMBEcXCJvOLFQizsd7tbpZaNFxw==
=OCYQ
-----END PGP SIGNATURE-----

--2Ogrk0EEy4DCWLZQicDrILMPI9qf87sjn--
