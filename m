From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 09 May 2007 16:57:01 +0200
Message-ID: <4641E13D.906@bull.net>
References: <20070503140804.463b20e1@naruto>	<463B4A1B.4070201@bull.net>	<20070507111952.7868bc1c@gara>	<4641BBB7.8020904@bull.net> <20070509085547.4785bf7d@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39605 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbXEIO6G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 10:58:06 -0400
In-Reply-To: <20070509085547.4785bf7d@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jose R. Santos wrote:
> I think this has more to do with the fact that I'm on a 32bit
> architecture and there are still a couple places where blocks are
> represented using "unsigned long".  I'm trying to get access to a 64b=
it
> arch to confirm this.
>=20
> -JRS
>=20
Oh, I didn't catch that you use a 32-bit system.
On 32-bit architectures, the page cache index size imposes a 16TB limit=
=20
on the filesystem size (with 4KB blocksize). So you need a 64-bit syste=
m=20
for your test.
   Val=C3=A9rie
