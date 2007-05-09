From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 09 May 2007 14:16:55 +0200
Message-ID: <4641BBB7.8020904@bull.net>
References: <20070503140804.463b20e1@naruto>	<463B4A1B.4070201@bull.net> <20070507111952.7868bc1c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38435 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXEIMSA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 08:18:00 -0400
In-Reply-To: <20070507111952.7868bc1c@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jose R. Santos wrote:
> Hi Valerie,
>=20
> I tried the patches and while the tools such as mkfs and debugfs seem
> to work fine, I am still unable to mount a filesystem with block
> numbers exceeding 32 bits.  I am testing on a 2.6.21.1 kernel with th=
e
> ext4 patches from:
>=20
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.2=
1-ext4-1
>=20
> The following error shows up on the kernel log:
>=20
> [12145.598822] EXT4-fs error (device dm-2): ext4_check_descriptors: B=
lock bitmap for group 0 not in group (block 18446744069414584320)!
> [12145.670781] EXT4-fs: group descriptors corrupted!
>=20
> So its failing very early in ext4_check_descriptors().  The hi 32 bit=
s of block_bitmap for the first group seem to be set all to 1s.
>=20
Hi Jose,
I'm sorry to reply so late, I had a day off yesterday.
I only tested the tools on an x86_64 system. Could it be an endianess i=
ssue?
On which platform do you run?
    Val=E9rie
