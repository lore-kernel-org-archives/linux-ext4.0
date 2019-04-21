Return-Path: <SRS0=dI79=SX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE61BC10F14
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 08:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9324A2087F
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Apr 2019 08:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="AP7jLe/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfDUIVH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Apr 2019 04:21:07 -0400
Received: from mout.gmx.net ([212.227.17.22]:36883 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfDUIVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Apr 2019 04:21:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555834855;
        bh=PGa2CZi3L9Ei3aNEQKkjb29t7xFsPvP/5QVDRiYGOJU=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=AP7jLe/pHTqSQCdb4FmrCkgFcBWW/1rUrkb/MSodkIJKAUggEdTr6rJKdpdvs1Pio
         g+oCSZ2rljXDyvJzabWBtmSTRhbz4jJAD7t23oy32knAki+Y5WEAXp1fqrGOXYHD4K
         icLYSxDaDTMAusTPp51GSWRHwAUb+9FC7MeA0LPo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MNdxu-1hC675409C-007Ag9; Sun, 21
 Apr 2019 10:20:55 +0200
To:     linux-arm-kernel@lists.infradead.org,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [aarch64] Kernel crash on v5.1-rc5, __arch_copy_from_user+0x1bc/0x240
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
Message-ID: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
Date:   Sun, 21 Apr 2019 16:20:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="guWK1S3GG53pEOZm7rVIeSDXNKJz5yfB4"
X-Provags-ID: V03:K1:XSbBMdwnFF8mHUYL3igPAGlNorIHhimw8Lo2v1yjWZfS3x5aFDP
 WfMN6AoCjyGZsxEn4g7BdMSW0qsNOhFYB11t3ViaTAMk49Xz5RLBNXNKHVqtFH89w1IOMNA
 PCVP/Qy1Pk7NOhU4jPGKPkrosPpGUqql2+LF/qsYGGkepiFycfG3YYEhb9CiguTCO2K1h4a
 4piEq9FyVuwyviYGgdzrQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:d20u2Rb4/P8=:UnccBXOiE1DeumLOTXubod
 r8jtME4AUZ7vJ5dH9raEXJJ1TvAhThB05F0OdFf+W+L30Gwn0DYm4whrmVP7eRRUmdGzvlJDg
 1DPvh7jJSj3BAWX0MCXq55LMVi89an2d7AakRFfd35nlcbTKnstJODk7vaaJsfgdgJ3A8gZvi
 6RpuAu5ydWFf+EYAcMdMMdmBBmkHcpeQ6xIFAk4hTE7h7WoL8Z6vdlydVEF/ubQ02mzChRKFj
 kEGqlO+jwWI+7lf2aZ2KMNpDiyVzeAN4FG668oT276QXgugtGS1CpQVptBzqlRed1IfArX1U3
 i5QNaVZek6Y6sR41ICB7WFq4gWGoQI0kQQhh1DA57+Jry05KHUgiA0bzItekz5y6kQc4IhbkY
 05oQCyQuPAFkF2RQWe8+xMJwZBGNld9SgS+th0LvItVOKY5FAyrP5YM4Iqmk3foilkuXFQ/q7
 6L7y8+s0YqWcWvp4jE/EEAtq0xXwDfrxYSXxbtXyZxqe7XxHx3yiTszpB0MDgktbVQP5fnNUl
 AwRDPQE1lBv6kK9L9EGzeuUX1xNMfjA9e8/3WstgaigV64Pf5F4UQAOTBv2We8L6agCLZVqiX
 NnPFhN6WqTChM8Y42a2C9tBrof8gMUfRXtAk0sPUKpleLNMxY5iXv1KqatXMeSX84HTl0N5rM
 g+nBHjjIfkm/PU+unn0p5hVMvrjtrytPpFC+UcyfvisScYsz5APq76dOqVLZ+QcUrEWezZeWS
 5Fg4mO1zZqN7UTm43FQ15TaoKGBUS88BGLnmxFfVzKwF3Wb4R0g+QbK75uSM71uGMGIfwcIZw
 YKBc3CQm3v5wtW9iMNy7ihRr44AuIBlWSPLW2sT8kgk/GCyFiOghvEy3fGvWv1iIepXyycFzP
 7dQfjVJHcnZcGsbifD0aFUy8nb6yATHm2N7o24g4ON4EgspdBhAteXzMOOT9aG
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--guWK1S3GG53pEOZm7rVIeSDXNKJz5yfB4
Content-Type: multipart/mixed; boundary="3wN0rd9R5KpgBHCdGuXOfzOWd6SJRkapm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-arm-kernel@lists.infradead.org, Ext4 <linux-ext4@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>
Message-ID: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
Subject: [aarch64] Kernel crash on v5.1-rc5, __arch_copy_from_user+0x1bc/0x240

--3wN0rd9R5KpgBHCdGuXOfzOWd6SJRkapm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.

The workload is some git checkout.
(Yeah, I'm compiling aarch64 kernel native, and have already compiled
mesa with panfrost successfully)

IIRC it's not the first time of crash, when checking out mesa, it
crashed before, but I didn't get the crash log.
The fs passes fsck.ext4 -f.

It doesn't look like it's ext4 to be blamed, but the ARM part.

Any idea on this bug?

Thanks,
Qu

[ 1575.697824] SError Interrupt on CPU1, code 0xbf000000 -- SEr
[ 1575.697827] CPU: 1 PID: 8593 Comm: git Tainted: G        75.697828]
Hardware)
[ 1575.697829] pstate: 20000005 (nzCv daif -PAN -UAO)
[ 1575.697831] pc : __arch_copy_from_user+0x1bc/0x240
[ 1575.697832] lr : copyin+0x54/0x68
[ 1575.697833] sp : ffff000019bbbb20
[ 1575.697834] x29: ffff000019bbbb20 x28: 0000000000000000
[ 1575.697837] x27: 0000000000001000 x26: ffff000010eac0f0
[ 1575.697839] x25: ffff000019bbbd60 x24: 0000000000001000
[ 1575.697842] x23: 0000000000001000 x22: ffff800009c01000
[ 1575.697844] x21: ffff000019bbbd50 x20: 0000000000001000
[ 1575.697846] x19: 0000000000000000 x18: 0000000000000000
[ 1575.697849] x17: 0000000000000000 x16: 0000000000000000

[ 1575.697851] x15: 0000000000000000 x14: 656c62616e653e2d

[ 1575.697854] x13: 7069686328206669 x12: 09090a3b31203d2b

[ 1575.697856] x11: 20746e756f635f65 x10: 6c62616e653e2d70

[ 1575.697858] x9 : 69686309090a7b20 x8 : 702026262031203d

[ 1575.697861] x7 : 3d20746e756f635f x6 : ffff800009c00098

[ 1575.697863] x5 : ffff800009c01000 x4 : 0000000000000008

[ 1575.697865] x3 : 5748206573616309 x2 : 0000000000000ef8

[ 1575.697868] x1 : 0000fffffbe5e850 x0 : ffff800009c00000

[ 1575.697871] Kernel panic - not syncing: Asynchronous SError Interrupt

[ 1575.697872] CPU: 1 PID: 8593 Comm: git Tainted: G         C
5.1.0-rc51
[ 1575.697873] Hardware name: Pine64 RockPro64 (DT)

[ 1575.697874] Call trace:

[ 1575.697876]  dump_backtrace+0x0/0x168

[ 1575.697876]  show_stack+0x24/0x30

[ 1575.697877]  dump_stack+0xac/0xd4

[ 1575.697878]  panic+0x150/0x2e8

[ 1575.697879]  __stack_chk_fail+0x0/0x28

[ 1575.697880]  arm64_serror_panic+0x80/0x8c

[ 1575.697881]  do_serror+0x11c/0x120

[ 1575.697883]  el1_error+0x84/0xf8

[ 1575.697884]  __arch_copy_from_user+0x1bc/0x240

[ 1575.697885]  iov_iter_copy_from_user_atomic+0xe4/0x3b8

[ 1575.697886]  generic_perform_write+0xe8/0x1a8

[ 1575.697887]  __generic_file_write_iter+0x134/0x1a0

[ 1575.697888]  ext4_file_write_iter+0x1fc/0x380

[ 1575.697889]  new_sync_write+0x108/0x158

[ 1575.697890]  __vfs_write+0x74/0x90

[ 1575.697891]  vfs_write+0xac/0x1b8

[ 1575.697892]  ksys_write+0x74/0xe8

[ 1575.697893]  __arm64_sys_write+0x24/0x30

[ 1575.697894]  el0_svc_handler+0x90/0x118

[ 1575.697895]  el0_svc+0x8/0xc

[ 1575.698031] SMP: stopping secondary CPUs

[ 1575.698032] Kernel Offset: disabled

[ 1575.698033] CPU features: 0x002,21006008

[ 1575.698034] Memory Limit: none


--3wN0rd9R5KpgBHCdGuXOfzOWd6SJRkapm--

--guWK1S3GG53pEOZm7rVIeSDXNKJz5yfB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly8J+EACgkQwj2R86El
/qijHwf+IbfhNlqOsnr0QPOnXUeoP+F/WFLZPHUzNB18E//qz2/TeIV7LS/6Dkl6
Aq121OicjtSJrRwNWNrIiczMXNf8rF9Sj6ylF4yMs3u1QbesiT2VljcBFAODaTJC
snkBqJbQNkgYNoRQGC/KJY713kS3zj5NXYN/3MgUTKCAJLYnN4DZ+4q3PTo/fIGJ
uUWQb6ye1IWFWnFHfmY6OOwHO4oeiUWI/zI1kG3HuHIhvU64FlGzHLWjNI3j6oTJ
kevdHRD3JhnC8sM38qZmguuHmYc4c73zGa/UnkxUu2n29x8r855xklID9rEk7H4S
ewPmbPtAs1d5h4tE0yWqtqTb3O31AQ==
=Slfc
-----END PGP SIGNATURE-----

--guWK1S3GG53pEOZm7rVIeSDXNKJz5yfB4--
