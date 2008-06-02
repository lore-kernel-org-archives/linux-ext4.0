From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Test results for ext4
Date: Mon, 2 Jun 2008 09:44:10 -0500
Message-ID: <20080602094410.390f0f22@rx8>
References: <48402253.8040407@bull.net>
	<20080530131239.6d93f1d9@rx8>
	<4843F924.1050109@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:38705 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYFBOpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 10:45:55 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m52EjrqI019996
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 10:45:53 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m52Eji4i120116
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 08:45:47 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m52Ejh12016789
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 08:45:43 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m52Ejgmv016760
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 08:45:42 -0600
In-Reply-To: <4843F924.1050109@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 02 Jun 2008 15:44:04 +0200
Valerie Clement <valerie.clement@bull.net> wrote:

> Jose R. Santos wrote:
> >         agefs=3D1
> >         [threadgroup0]
> >                 num_threads=3D10
> >                 write_size=3D40960
> >                 write_blocksize=3D4096
> >                 create_weight=3D10
> >                 append_weight=3D10
> >                 delete_weight=3D1
> >         [end0]
> >                 desired_util=3D0.80
> >=20
> > This will age the filesystem until it reaches 80% utilization befor=
e
> > starting the benchmark.  Since a 5TB disk will take a while to age,
> > I suggest trying this on just a few runs.
> Ok to do it only on a few runs (creating a 4TB file on my device take=
s
> more than 12 hours...)
>    Val=C3=A9rie

Wow...

Maybe running aging on a 5TB fs is not such a good idea.  I think it
would be better to run it on a smaller array size (1TB maybe).  I
suspect that one of the reasons this is taking so long is that with 4TB
of small files, the rbtree in FFSB would be huge and could be larger
than the 2GB of memory you are running on your system, causing you to
swap.


Running on a smaller FS should still give a good idea of how well the
filesystems avoid fragmentation.


-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
