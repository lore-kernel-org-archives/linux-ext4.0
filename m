From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Wed, 18 Jun 2008 05:58:00 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de>
References: <18563.1213215457@alphaville.zko.hp.com>
 <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker>
 <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:57478 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbYFRF6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2008 01:58:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by node2.dwd.de (Postfix) with ESMTP id 0D35F4A43DA
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 05:58:08 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node2.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 32107-85 for <linux-ext4@vger.kernel.org>;
	Wed, 18 Jun 2008 05:58:07 +0000 (UTC)
In-Reply-To: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Jun 2008, Holger Kiehl wrote:

> Doing several test with '-m 0' I was unable to reproduce this and I could
> now do several runs with afdbench. However the results do show that with
> ext4-patch-queue it actually slower:
>
> For ext3:             5449.76 files per second 15.58 MiB/s
> For ext4:             5162.16 files per second 15.48 MiB/s
> For ext4+patch-queue: 4963.6975 files per second 14.73 MiB/s
>
> On the positive side the bonnie++ numbers got much better:
>
> Version  1.03       ------Sequential Output------ --Sequential Input- 
> --Random-
>                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec 
> %CP
> ext3            16G 51501  97 210601 91 100479 32 55528  98 301589 44  1198 
> 5
>                16G 52702  98 215540 94 99339  32 55376  97 300933 44  1159 
> 4
>                16G 52426  99 212584 94 99091  31 55656  98 301669 44  1160 
> 4
> ext4            16G 52965  98 224199 89 108440 32 56389  99 303792 42  1526 
> 4
>                16G 52792  98 223980 92 107685 32 56350  98 303066 42  1532 
> 4
>                16G 52994  98 222354 92 107802 32 56386  99 303727 41  1455 
> 4
> ext4(patchqueue)16G 59727  98 252733 52 110177 25 55821  98 296739 42  1553 
> 5
>                16G 61047  99 239242 48 111664 25 55706  98 297151 42  1545 
> 4
>                16G 60503  99 241532 47 109655 25 55671  98 297648 42  1552 
> 3
>
> ext3 and ext4 tests where done with 2.6.25.4 and those with patch-queue was
> 2.6.26-rc5. I will do another test run with 2.6.26-rc5 without patch-queue
> just to make sure that the slowdown does not happen due to changes in the
> 2.6.26 branch.
>
Here the results without patch queue:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
                 16G 52133  98 221378 95 106873 32 55707  99 297065 42  1546   4
                 16G 52042  98 220931 93 107715 32 55939  98 298810 42  1543   3
                 16G 52975  98 220976 93 108060 31 56426  98 298906 42  1452   4

For afdbench: 5336.41 files per second 15.63 MiB/s

So it seems that for afdbench the ext4-patch-queue is a slowdown.

I forgot to mention that for bonnie ext4-patch-queue reduces CPU-load
a lot. For block writting it is nearly halved.

Holger

