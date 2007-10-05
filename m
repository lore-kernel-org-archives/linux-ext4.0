From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
Date: Fri, 05 Oct 2007 15:41:07 +0200
Message-ID: <47063EF3.4050302@bull.net>
References: <4705113A.7030908@bull.net> <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42952 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXJENlU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2007 09:41:20 -0400
In-Reply-To: <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
> On Thu, 2007-10-04 at 18:13 +0200, Valerie Clement wrote:
>> While running ffsb tests on my ext4 filesystem, I got an Oops in=20
>> cache_alloc_refill().
>> I turned on SLAB debugging and here is the message I got:
>>
>> slab: Internal list corruption detected in cache 'buffer_head'(30),=20
>> slabp ffff81007e100100(1515870810). Hexdump:
>=20
> slabp->inuse =3D 1515870810 looks bogus. Is this easily reproducible =
?

Hi Badari,
Thanks for your answer.
I didn't reproduce it without the latest ext4 patches. So I suspect a=20
bug in one of them.
But how debugging this?
Which other debug traces can I turn on?

   Val=C3=A9rie
