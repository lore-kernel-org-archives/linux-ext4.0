From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH 6/6] delalloc ENOSPC: improve percpu
	counter	accounting accurate
Date: Sun, 01 Jun 2008 19:30:25 -0700
Message-ID: <1212373825.4368.74.camel@localhost.localdomain>
References: <1212363385.4368.69.camel@localhost.localdomain>
	 <48433CAA.1050209@rs.jp.nec.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35738 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYFBCar (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 22:30:47 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m522UUmX025793
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 22:30:30 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m522UUlJ150122
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 22:30:30 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m522UUaF009482
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 22:30:30 -0400
In-Reply-To: <48433CAA.1050209@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-06-02 at 09:19 +0900, Akira Fujita wrote:
> Hi,
>=20
> > Mingming Cao wrote:
> > percpu counter: update center counter when sum per-cpu counter
> >
> > From: Mingming cao <cmm@us.ibm.com>
> >
> > Delayed allocation need to check free blocks at every write time.
> > percpu_counter_read_positive() is not quit accurate
> >  but using percpu_counter_sum_positive() for every write
> > frequently is quite expensive.
>=20
> I couldn't compile the latest ext4 patch qeueu.
>=20
>   LD      fs/ext3/ext3.o
>   LD      fs/ext3/built-in.o
>   CC      fs/ext4/balloc.o
> fs/ext4/balloc.c: In function =E2=80=98ext4_has_free_blocks=E2=80=99:
> fs/ext4/balloc.c:1629: error: implicit declaration of function =E2=80=
=98percpu_counter_sum_positive_set=E2=80=99
>=20
>=20
> > +		    percpu_counter_sum_positive_set(&sbi->s_freeblocks_counter);
>=20
> Maybe the above line which in percpucounter-add-sum-and-set-function.=
patch
> is percpu_counter_sum_and_set(&sbi->s_freeblocks_couter).
>=20

oops. Updated patch queue, please check again.

Mingming
> Thanks,
> Akira Fujita
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
