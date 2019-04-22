Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E67C10F14
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 01:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289902075A
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 01:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="AQKGyMnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfDVBOp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Apr 2019 21:14:45 -0400
Received: from mout.gmx.net ([212.227.15.19]:33177 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfDVBOo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Apr 2019 21:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555895668;
        bh=TxxlistYA9pa2RMTu9j2LmUjpbl4O5KH0Ago8p4MWDI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=AQKGyMnPwxjTuYbnsvTvn9MVGFtJYCeilXWLDXadUnJrfKUC6XqVuuVEP6l5Y0G0Q
         6NQp1nW6gx2mKgnGAnXWd/ySchCtjCf92wtc5Jhc5EYP2vLLBp7YD2W8/Gq1sdZGQu
         twrZUEm8BYd/EmrT2fqFKuI/kXqt4QrrpkW9w9Pw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LiTJE-1gg1WB2Gp2-00ciff; Mon, 22
 Apr 2019 03:14:28 +0200
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
 <20190421132840.GK7751@bombadil.infradead.org>
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
Message-ID: <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
Date:   Mon, 22 Apr 2019 09:14:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190421132840.GK7751@bombadil.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YpfZityYwuZ8KxowK7EzCAH3uj4DtNqE3"
X-Provags-ID: V03:K1:MNHdlJR30ralO92iVWjkIj/qaKxd6COh+lpfS6M3W3PZwMSslHl
 rcwBar8ekxDU9etY7+1NiKJrvtMkhYepXgWEKqgY3rOvBOmDJTAsX8YjS1LmIn253VxnyH2
 FcpHypmEezrBvWft66ezlhGozCOmiG3L5WqWh4mhfyKAyXMHgS6FFF3rghc42uuhgf2AsR3
 bbSU+QIPJTmFGkbXD1rOw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qws4icjf3aY=:xlqYMnbaZjqn73GdC24ikr
 n7DbbuRxcMlnvMkpIkZkd0NGRlLhnBVrECacqTUssfUFHJ7TH5/UPonL/BnTBKSW6bdyn0YZz
 R6oH8b2mU2qZI39Soquf+FhGzSDDWTlOVl/c4cxCMwnLz6Swlw1hHzdTSqtwG65rSi7MOIapd
 kpm6aqye3sAyPP4z91M8TOuzuRwIwWN0Di5Szlo+eCsuS2+42f42FyPpZzGi/BSibMLYbrZnA
 YRUOZlOVXVDQSDqcvkI5ZRRwwNfPnLPP8i1S2LyNlQyZAScrpLibDpkvSJFxr7P+XhP5V5Qt0
 4YJCsQXGPSF9MmiCQCZak0hm0fkKaBcpjKrEXUQx102jya9fMKcbQdjxIJMlJkFsl4DxwLajw
 FeZlO+6J4aupWKhkx9npdi3WEfydPRNgJON/2rbb4nUWRoUBuyB/eGGrAvR5pxgbj6aOCvTY4
 jyWEjKQqhgrkzJXlOjU07hDjz/W8FeDb7IPEWRZL39gepO9E2Rp0+j62D/TvLXhS/9AY20lfU
 MHfny1RAnfxssuivRgbZ5ctQPP5DdpnFE0RWvcgoAkwuw4KqS5bJ6IbakjCXhMRtiaFxrst9V
 nkPKCQS2ooXwLQA306hPsCwUqL7Ae5I4zO9RPnuk1fV/L7yD6sc2hTIET/Ear3/vaYSJhJAnp
 /43Q8g4zQ/abvM3qeODFgrIacG5hgAIm7n0sFYGquSMWh2gxOSlRwFKiLuShHkBuPS4sv7kil
 CF0YWqzjOIRSvlddfnSKsJeyuewOe3kg8wNcNZ3TPeHPM8x+2AomOt+bJJ1CYREmNhr0NFpVF
 phRWj/S/PcN4iewTGQiuUfStwyjmqrkHkfjUoxmKTiZx3tvcCeXF2wkV/jjJBGpotuF/TGxwy
 C/Nq8Y2DClu+8C1BZQhK8IBG63NE8g50gxfPSu0t5kxR8sK9R78ld71tols8aV
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YpfZityYwuZ8KxowK7EzCAH3uj4DtNqE3
Content-Type: multipart/mixed; boundary="WUTFcEiGQwFUYgp7bLPS7MfWe82h3AtPL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, Ext4 <linux-ext4@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>
Message-ID: <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
 <20190421132840.GK7751@bombadil.infradead.org>
In-Reply-To: <20190421132840.GK7751@bombadil.infradead.org>

--WUTFcEiGQwFUYgp7bLPS7MfWe82h3AtPL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/21 =E4=B8=8B=E5=8D=889:28, Matthew Wilcox wrote:
> On Sun, Apr 21, 2019 at 05:12:50PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/21 =E4=B8=8B=E5=8D=884:20, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.
>>
>> Well, also hit the same one in v5.0.8 kernel.
>>
>> Exact the same backtrace.
>>
>> Really not sure which part is to blame, ARM or ext4?
>=20
> You probably have faulty hardware:
>=20
> https://community.arm.com/developer/ip-products/processors/f/cortex-a-f=
orum/3205/re-what-is-serror-detailed-explanation-is-required
>=20
You're right.

I tried memtester, and kernel also crashed.

Maybe it's really faulty memory or I'm using wrong memory speed.

Anyway, thanks for the info,
Qu


--WUTFcEiGQwFUYgp7bLPS7MfWe82h3AtPL--

--YpfZityYwuZ8KxowK7EzCAH3uj4DtNqE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly9FWwACgkQwj2R86El
/qjcggf7BOgLe/d+uRxskUC22L+5ygDe/Bovmaw9xUb4K/PqxxsjoCT29muftqGP
6ykYBBSc8XnYfhHph7V4MXulYeFLXomsP+9RoRyNPmhBBjgKhs/fQW8xLA0vSWnW
yIo+gLLPioe499N6AlsVa6BTlshfQyWa93fixW9sTNfNmAP5mmMnHiC1IxV6iFYY
oFPRBBqyCinpd+SMEI1ODn/45vZshViotewQn91nQxpAtdk489+BSg8VqxBoGNRk
jZCw0cA1zic2mTFSBm5KHpS0IgSMJC8ImwzGQr3yHnbFmHd+Ugka56dklVOzmJv5
w/NnkFlcm47xQTe0aRNqjCb7qAsxaA==
=P6xH
-----END PGP SIGNATURE-----

--YpfZityYwuZ8KxowK7EzCAH3uj4DtNqE3--
