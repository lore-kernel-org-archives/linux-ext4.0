From: "jon ernst" <jonernst07@gmx.com>
Subject: Re: "block_dump, bd" in debugfs
Date: Wed, 26 Jun 2013 23:58:30 -0400
Message-ID: <20130627035830.253590@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:63892 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3F0D6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 23:58:33 -0400
Received: from mailout-us.gmx.com ([172.19.198.48]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0MLfoV-1UrEP73Gr5-000wlg for
 <linux-ext4@vger.kernel.org>; Thu, 27 Jun 2013 05:58:30 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message -----
=46rom: Eric Sandeen
Sent: 06/26/13 11:39 PM
To: jon ernst
Subject: Re: "block_dump, bd" in debugfs
 On 6/26/13 11:05 PM, jon ernst wrote:
>> Hi,=20
>> When I use "block_dump" to dump certain block. I got 12288 bytes dum=
ped.

>output example? It dumps a hexadecimal representation w/ octal
>offsets, if you're counting bytes in the *text* output it'd be more th=
an 4096.


This is example:
7020 =C2=A0ae1c aefc aef4 aedf ae65 ae83 ae2e ae19 =C2=A0.........e....=
=2E.
7040 =C2=A0aef5 ae00 ae69 aebc ae66 aeb0 ae88 aea6 =C2=A0.....i...f....=
=2E.
7060 =C2=A0ae4d aed3 ae67 ae9d ae10 ae6e aef0 aec5 =C2=A0.M...g.....n..=
=2E.
7100 =C2=A0aed4 ae63 ae10 ae57 ae55 aee6 ae79 aec4 =C2=A0...c...W.U...y=
=2E.
7120 =C2=A0aede aee6 ae35 aea3 ae84 aee3 aed5 aea1 =C2=A0.....5........=
=2E.
7140 =C2=A0aed3 ae6b ae99 ae88 aee4 ae60 ae6b aee2 =C2=A0...k.......`.k=
=2E.
7160 =C2=A0ae5d ae6a ae8c ae4c ae19 ae62 aeb1 ae8e =C2=A0.].j...L...b..=
=2E.
7200 =C2=A0ae4b ae55 aedf aea2 ae93 ae42 ae59 ae36 =C2=A0.K.U.......B.Y=
=2E6
7220 =C2=A0ae44 aed8 aedc aeb9 ae5c ae9f aea9 aeb9 =C2=A0.D.......\....=
=2E.
7240 =C2=A0ae85 aec3 ae1a ae11 aeae ae32 aed7 ae78 =C2=A0...........2..=
=2Ex
7260 =C2=A0ae89 aeae ae04 aec7 ae6c ae9d ae4f aea6 =C2=A0.........l...O=
=2E.
7300 =C2=A0ae71 ae0d ae67 aea3 ae2c ae38 ae61 ae44 =C2=A0.q...g...,.8.a=
=2ED
7320 =C2=A0aead aeaa ae3d ae61 ae72 ae66 ae25 ae7f =C2=A0.....=3D.a.r.f=
=2E%..
7340 =C2=A0aeb6 ae1b ae22 ae43 aeab ae0a aec5 aed9 =C2=A0.....".C......=
=2E.
7360 =C2=A0ae97 ae72 ae62 ae65 ae59 ae0a ae22 aed1 =C2=A0...r.b.e.Y..."=
=2E.
7400 =C2=A0ae7c aefa ae31 aebe aeaf ae45 aec5 aefd =C2=A0.|...1.....E..=
=2E.
7420 =C2=A0aece ae79 aef5 aee8 ae9e ae7c ae99 ae24 =C2=A0...y.......|..=
=2E$
7440 =C2=A0aee2 aee2 aeaa aec7 ae45 ae53 ae00 ae5e =C2=A0.........E.S..=
=2E^
7460 =C2=A0ae04 aef6 aeb3 aede ae11 ae53 ae4d aee2 =C2=A0...........S.M=
=2E.
7500 =C2=A0aef7 aefe ae3f aedb aec3 ae7f ae1e ae8b =C2=A0.....?........=
=2E.
7520 =C2=A0ae3a ae61 aeb3 aea2 ae43 ae01 ae66 ae48 =C2=A0.:.a.....C...f=
=2EH
7540 =C2=A0aec8 ae48 ae33 ae47 aefc ae93 aea0 ae89 =C2=A0...H.3.G......=
=2E.
7560 =C2=A0aea3 aeb4 ae3a ae76 ae21 aee3 aec1 aee5 =C2=A0.....:.v.!....=
=2E.
7600 =C2=A0ae15 ae41 aeb0 ae5b aead ae32 ae20 ae24 =C2=A0...A...[...2. =
=2E$
7620 =C2=A0aed0 ae01 ae15 ae5f aebf ae03 aed3 aeb4 =C2=A0......._......=
=2E.
7640 =C2=A0aecc ae89 aeff aecb ae13 ae26 aee1 ae43 =C2=A0...........&..=
=2EC
7660 =C2=A0ae1f ae24 aeef aef2 ae06 ae3d aec0 ae20 =C2=A0...$.......=3D=
=2E..
7700 =C2=A0ae01 ae37 ae34 aea1 ae45 ae19 aec6 aea2 =C2=A0...7.4...E....=
=2E.
7720 =C2=A0ae0b ae99 ae2b aea3 aedf aedd aed6 ae69 =C2=A0.....+........=
=2Ei
7740 =C2=A0ae9a ae8e ae0b ae8b aede ae9b ae0c ae12 =C2=A0..............=
=2E.
7760 =C2=A0ae42 ae44 ae04 ae0b aec9 ae62 aedd ae95 =C2=A0.B.D.......b..=
=2E.
 =C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
