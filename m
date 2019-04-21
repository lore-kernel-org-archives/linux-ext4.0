Return-Path: <SRS0=dI79=SX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FEFC282E1
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 09:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 075412147C
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 09:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VmFTVV9s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfDUJNH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Apr 2019 05:13:07 -0400
Received: from mout.gmx.net ([212.227.15.19]:54489 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfDUJNH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Apr 2019 05:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555837977;
        bh=t6pTybyXJ2yZkgvr6/F1Q2vhbhO4KUoox3Uwjp2ReSQ=;
        h=X-UI-Sender-Class:Subject:From:To:References:Date:In-Reply-To;
        b=VmFTVV9sDFrj54i/hpucJqq20zvcvQ2S6lpZ9Mx3ZZm3VKGGMwLnnugUTd/EzlxJC
         HPY9ll+9aPV9oIJB64E1vWHEnGRtCpmLGNozFdrsM1LwUgiCHNwoDMUXSElP5JH86z
         MloVHxETZvux6c5Wk5Tppr73fF+n1zCtkPEh+Kho=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MQzIE-1hOEA220hK-00UINy; Sun, 21
 Apr 2019 11:12:57 +0200
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     linux-arm-kernel@lists.infradead.org,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
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
Message-ID: <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
Date:   Sun, 21 Apr 2019 17:12:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LIC8t9sDeucEp4QlOcX0XvKdGJnAFmazE"
X-Provags-ID: V03:K1:Jz2oFZD+7sTa9mwRIjSAV6JUA7dXOspSESW0UxLxTakZvp66Fgz
 qAvWB0WP1v3StTg8Z+dQHV/qZ+u9H83decHZR/mFGnKAE8Ifk1Js4yycz5aQy/z3DWG0sy1
 MjGRIwYqHH3i+ZKFQbVikinwdnEJ+SSg6j/XwOPdPoM9b0XRZlvcht6zIibd8woPmH2pZka
 +Mfi+PneRrxVimwB1Ajxw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NGwqlMExT8Y=:OGbenYsmoyAcc8a7hPQlZS
 ut1sdp1vMh2oozCjaiz4I6onCGuCSjTB+ckOKbK73Hc41WwcIzRc3TOOJvVR5MLCA/5to4Ps7
 vPsG40ZZ60DL+SMzYgedyaE18h6qOi3goiLT0QU+yzQflMbQe9oxwY9A6WTgjimeO9jj4nf+G
 c+9bMq623vL5GkFPKmSt7dsyBT4tCBQkaITUQoI76+5KaCF6Cub2SMbcxgAMTUCqCCH79y/W4
 hVQtfTv9NwA1+igTV/u79RmNRysu6ZAx9+XF5JqbOdGb00DXm9Eb4mKP2xxnpprJC+ceS7de/
 H11KNw2MGhBrFxSRiJwNUP1lChuttZFIEgHHAmfZHvzg1HFhEf3UGVuWIQ+5cb6ogHC8Hmvc9
 xlKiAUpJ9gLJPjllELf2jOCovWeN2YlXTQpCCyvp3q0TO/OczGVgWs+276KwDB4KBmmvI/70q
 IpiweN2Jge0F5/IIM149K1FjoUAHCIoG5Ub7eaDwttDu+uaLR7NB1xIoG2DZSFbcrvE/VatVI
 Ha2VbQfho/F8GjCOeGA3/N57P0t1JleGY6sOmQCD2I0JlpYb0E2/wt8dHxAaIbzLbteQ9ZMs7
 qdMD0uIf08tCOI5m5a6X4+IMjf8iKBBaZt0VGTIrBC0/arKGKIiY9hOPdF8i9C/iZxGM+O8Tt
 RXitwBEJ4o/9OC0PaUMT8lVPGd/SiYDyYbVbhT5Fj4QcuY33Xw4zGAj5mz1OnFjnQuWFINZN5
 ZVnDHRRm9Db8lpzNXIv754aisY0JRWG3o4FxtjUhrsidGlI6b9Ck+ibYnGenmSxDL8hZs5AgT
 zk7opEpYnqFXiGENjkqsGRLuGCv+CgCU8Oa1saNX13idoBRFrHDyU/Mun5AokkTHKEMa44JAj
 ZHc5aD+DlQJ5SliClgvgNqAjKy2vUPb+YPBzvQa1t8LwrMh68WMYaRq15VUPtF
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LIC8t9sDeucEp4QlOcX0XvKdGJnAFmazE
Content-Type: multipart/mixed; boundary="Dk9sP99S4RN2DPmhPPCsYd8NGyjT7GTgy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-arm-kernel@lists.infradead.org, Ext4 <linux-ext4@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>
Message-ID: <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
In-Reply-To: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>

--Dk9sP99S4RN2DPmhPPCsYd8NGyjT7GTgy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/21 =E4=B8=8B=E5=8D=884:20, Qu Wenruo wrote:
> Hi,
>=20
> Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.

Well, also hit the same one in v5.0.8 kernel.

Exact the same backtrace.

Really not sure which part is to blame, ARM or ext4?

Thanks,
Qu

[   46.252636] rk_gmac-dwmac fe300000.ethernet eth0: Link is Ux
[   46.253425] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

[ 2784.731946] SError Interrupt on CPU1, code 0xbf000000 -- SError

[ 2784.731949] CPU: 1 PID: 6121 Comm: git Tainted: G         C
5.0.8-1-A1
[ 2784.731951] Hardware name: Pine64 RockPro64 (DT)

[ 2784.731952] pstate: 20000005 (nzCv daif -PAN -UAO)

[ 2784.731953] pc : __arch_copy_from_user+0x1dc/0x240

[ 2784.731954] lr : copyin+0x54/0x68

[ 2784.731955] sp : ffff000016e8bb70

[ 2784.731957] x29: ffff000016e8bb70 x28: 0000000000000000

[ 2784.731959] x27: 0000000000001000 x26: ffff000010e59e28

[ 2784.731962] x25: ffff000016e8bdc0 x24: 0000000000001000

[ 2784.731964] x23: 0000000000001000 x22: ffff800009c01000

[ 2784.731967] x21: ffff000016e8bd88 x20: 0000000000001000

[ 2784.731969] x19: 0000000000000000 x18: 0000000000000000

[ 2784.731971] x17: 0000000000000000 x16: 0000000000000000

[ 2784.731974] x15: 0000000000000000 x14: 3a2266664f544872

[ 2784.731976] x13: 65746e756f432220 x12: 0a2c223122203a22

[ 2784.731979] x11: 65726f6366664f22 x10: 2020202020202020

[ 2784.731981] x9 : 0a7b202020200a2c x8 : 7d202020200a2233

[ 2784.731983] x7 : 2c322c312c302220 x6 : ffff800009c00138

[ 2784.731986] x5 : ffff800009c01000 x4 : 0000000000000008

[ 2784.731988] x3 : 3178302c36613178 x2 : 0000000000000e78

[ 2784.731990] x1 : 0000ffffdfecf2e0 x0 : ffff800009c00000

[ 2784.731993] Kernel panic - not syncing: Asynchronous SError Interrupt

[ 2784.731995] CPU: 1 PID: 6121 Comm: git Tainted: G         C
5.0.8-1-A1
[ 2784.731996] Hardware name: Pine64 RockPro64 (DT)

[ 2784.731997] Call trace:

[ 2784.731998]  dump_backtrace+0x0/0x1c8

[ 2784.731999]  show_stack+0x24/0x30

[ 2784.732000]  dump_stack+0x98/0xbc

[ 2784.732001]  panic+0x14c/0x2e0

[ 2784.732002]  __stack_chk_fail+0x0/0x28

[ 2784.732003]  arm64_serror_panic+0x80/0x8c

[ 2784.732004]  is_valid_bugaddr+0x0/0x1c

[ 2784.732005]  el1_error+0x7c/0xe4

[ 2784.732006]  __arch_copy_from_user+0x1dc/0x240

[ 2784.732007]  iov_iter_copy_from_user_atomic+0xe4/0x368

[ 2784.732008]  generic_perform_write+0xe8/0x1a8

[ 2784.732009]  __generic_file_write_iter+0x134/0x1a0

[ 2784.732011]  ext4_file_write_iter+0x1fc/0x380

[ 2784.732011]  __vfs_write+0x150/0x188

[ 2784.732013]  vfs_write+0xac/0x1b8

[ 2784.732014]  ksys_write+0x6c/0xd0

[ 2784.732014]  __arm64_sys_write+0x24/0x30

[ 2784.732016]  el0_svc_handler+0x94/0x118

[ 2784.732016]  el0_svc+0x8/0xc

[ 2784.732152] SMP: stopping secondary CPUs

[ 2784.732153] Kernel Offset: disabled

[ 2784.732154] CPU features: 0x002,21006008

[ 2784.732155] Memory Limit: none

[ 2784.751574] ---[ end Kernel panic - not syncing: Asynchronous SError
Interru-

>=20
> The workload is some git checkout.
> (Yeah, I'm compiling aarch64 kernel native, and have already compiled
> mesa with panfrost successfully)
>=20
> IIRC it's not the first time of crash, when checking out mesa, it
> crashed before, but I didn't get the crash log.
> The fs passes fsck.ext4 -f.
>=20
> It doesn't look like it's ext4 to be blamed, but the ARM part.
>=20
> Any idea on this bug?
>=20
> Thanks,
> Qu
>=20
> [ 1575.697824] SError Interrupt on CPU1, code 0xbf000000 -- SEr
> [ 1575.697827] CPU: 1 PID: 8593 Comm: git Tainted: G        75.697828]
> Hardware)
> [ 1575.697829] pstate: 20000005 (nzCv daif -PAN -UAO)
> [ 1575.697831] pc : __arch_copy_from_user+0x1bc/0x240
> [ 1575.697832] lr : copyin+0x54/0x68
> [ 1575.697833] sp : ffff000019bbbb20
> [ 1575.697834] x29: ffff000019bbbb20 x28: 0000000000000000
> [ 1575.697837] x27: 0000000000001000 x26: ffff000010eac0f0
> [ 1575.697839] x25: ffff000019bbbd60 x24: 0000000000001000
> [ 1575.697842] x23: 0000000000001000 x22: ffff800009c01000
> [ 1575.697844] x21: ffff000019bbbd50 x20: 0000000000001000
> [ 1575.697846] x19: 0000000000000000 x18: 0000000000000000
> [ 1575.697849] x17: 0000000000000000 x16: 0000000000000000
>=20
> [ 1575.697851] x15: 0000000000000000 x14: 656c62616e653e2d
>=20
> [ 1575.697854] x13: 7069686328206669 x12: 09090a3b31203d2b
>=20
> [ 1575.697856] x11: 20746e756f635f65 x10: 6c62616e653e2d70
>=20
> [ 1575.697858] x9 : 69686309090a7b20 x8 : 702026262031203d
>=20
> [ 1575.697861] x7 : 3d20746e756f635f x6 : ffff800009c00098
>=20
> [ 1575.697863] x5 : ffff800009c01000 x4 : 0000000000000008
>=20
> [ 1575.697865] x3 : 5748206573616309 x2 : 0000000000000ef8
>=20
> [ 1575.697868] x1 : 0000fffffbe5e850 x0 : ffff800009c00000
>=20
> [ 1575.697871] Kernel panic - not syncing: Asynchronous SError Interrup=
t
>=20
> [ 1575.697872] CPU: 1 PID: 8593 Comm: git Tainted: G         C
> 5.1.0-rc51
> [ 1575.697873] Hardware name: Pine64 RockPro64 (DT)
>=20
> [ 1575.697874] Call trace:
>=20
> [ 1575.697876]  dump_backtrace+0x0/0x168
>=20
> [ 1575.697876]  show_stack+0x24/0x30
>=20
> [ 1575.697877]  dump_stack+0xac/0xd4
>=20
> [ 1575.697878]  panic+0x150/0x2e8
>=20
> [ 1575.697879]  __stack_chk_fail+0x0/0x28
>=20
> [ 1575.697880]  arm64_serror_panic+0x80/0x8c
>=20
> [ 1575.697881]  do_serror+0x11c/0x120
>=20
> [ 1575.697883]  el1_error+0x84/0xf8
>=20
> [ 1575.697884]  __arch_copy_from_user+0x1bc/0x240
>=20
> [ 1575.697885]  iov_iter_copy_from_user_atomic+0xe4/0x3b8
>=20
> [ 1575.697886]  generic_perform_write+0xe8/0x1a8
>=20
> [ 1575.697887]  __generic_file_write_iter+0x134/0x1a0
>=20
> [ 1575.697888]  ext4_file_write_iter+0x1fc/0x380
>=20
> [ 1575.697889]  new_sync_write+0x108/0x158
>=20
> [ 1575.697890]  __vfs_write+0x74/0x90
>=20
> [ 1575.697891]  vfs_write+0xac/0x1b8
>=20
> [ 1575.697892]  ksys_write+0x74/0xe8
>=20
> [ 1575.697893]  __arm64_sys_write+0x24/0x30
>=20
> [ 1575.697894]  el0_svc_handler+0x90/0x118
>=20
> [ 1575.697895]  el0_svc+0x8/0xc
>=20
> [ 1575.698031] SMP: stopping secondary CPUs
>=20
> [ 1575.698032] Kernel Offset: disabled
>=20
> [ 1575.698033] CPU features: 0x002,21006008
>=20
> [ 1575.698034] Memory Limit: none
>=20


--Dk9sP99S4RN2DPmhPPCsYd8NGyjT7GTgy--

--LIC8t9sDeucEp4QlOcX0XvKdGJnAFmazE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly8NBIACgkQwj2R86El
/qghPQf/Zr8RD114K6FbK9l/DvRRsAE/uopJZo4bCCIAL8DN5pDw/rjoYNuB0LZ6
V8uawTPbtsP40otKRzOI84cmqeiQbk9oDzEf+N0Yu2abq7j9sqqRkWzMv0yKLPzf
ZXqrOYMtFuMmbVJRT5B0cVtN/hljJ7qK5eL7cN7Kg8F4qtbOHKSH3z48T+yg73Bz
MpJ6/Xu/HRkAVIiGzXOk8pO8qkp3axN4bcZKJoXGK2KaTTg0LxxsqHvs4uaMZ114
t2rjMQgg+6gzJzqIAqqls0I2GUu8XmyL9FzFQONssv7PfkhP9uPcNhrI38yGCOiM
f4zruMeu9byDCIZ7OnytmB9X2V7lUw==
=9c33
-----END PGP SIGNATURE-----

--LIC8t9sDeucEp4QlOcX0XvKdGJnAFmazE--
