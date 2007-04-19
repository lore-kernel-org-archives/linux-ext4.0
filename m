From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 11:11:45 +0200
Message-ID: <46273251.4000403@bull.net>
References: <462622F8.10107@bull.net> <20070418135709.b499e050.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45919 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993211AbXDSJMk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 05:12:40 -0400
In-Reply-To: <20070418135709.b499e050.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> It could be due to I/O scheduler changes.  Which one are you using?  =
CFQ?
>=20
> Or it could be that there has been some changed behaviour at the VFS/=
pagecache
> layer: the VFS might be submitting little hunks of lots of files, rat=
her than
> large hunks of few files.
>=20
> Or it could be a block-layer thing: perhaps some driver change has ca=
used
> us to be placing less data into the queue.  Which device driver is th=
at machine
> using?
>=20
> Being a simple soul, the first thing I'll try when I get near a test =
box
> will be
>=20
> for i in $(seq 1 16)
> do
> 	time dd if=3D/dev/zero of=3D$i bs=3D1M count=3D1024 &
> done
>=20

I tried first the test with dd, the results are similar to those of FFS=
B=20
tests, about 15 percent of degradation between 2.6.20.7 and 2.6.21-rc7.

I'm using the CFQ I/O scheduler. I changed it to the "deadline" one and=
=20
I don't have any more the problem, I've got similar throughput values=20
with 2.6.20.7 and 2.6.21-rc7 kernels.
So can we conclude that it's due to the CFQ scheduler?

I also checked the device driver used, the revision number is the same=20
in 2.6.20 and 2.6.21.

   Val=E9rie
