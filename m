From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Test results for ext4
Date: Fri, 30 May 2008 13:12:39 -0500
Message-ID: <20080530131239.6d93f1d9@rx8>
References: <48402253.8040407@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35707 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbYE3SOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 14:14:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4UIDvkU026467
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 14:13:57 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UIDvu5103262
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 14:13:57 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UIDvUJ032399
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 14:13:57 -0400
In-Reply-To: <48402253.8040407@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 May 2008 17:50:43 +0200
Valerie Clement <valerie.clement@bull.net> wrote:

> Hi all,
>=20
> Since a couple of weeks, I did batches of tests to have some
> performance numbers for the new ext4 features like uninit_groups,
> flex_bg or journal_checksum on a 5TB filesystem.
> I tried to test allmost all combinations of mkfs and mount options,
> but I put only a subset of them in the result tables, the most
> significant for me.
>=20
> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got
> several hangs and crashes occuring randomly outside ext4, sometimes
> in the slab code or in the scsi driver eg., and which were not
> reproductible. Since 2.6.26-rc2, no crash or hang occur with ext4 on
> my system.
>=20
> The first results and the test description are available here:
> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.htm=
l
> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2=
=2Ehtml
>=20
> I will complete them in the next days.
>=20
> In the first batch of tests, I compare the I/O throughput to create
> 1-GB files on disk in different configurations. The CPU usage is also
> given to show mainly how the delayed allocation feature reduces it.
> The average number of extents per file shows the impact of the
> multiblock allocator and the flex_bg grouping on the file
> fragmentation. At last, the fsck time shows how the uninit_groups
> feature reduces the e2fsck duration.
>=20
> In the second batch of tests, the results show improvements in
> transactions -per-second throughput when doing small files writes,
> reads and creates when using the flex_bg grouping.
> The same ffsb test on an XFS filesystem hangs, I will try to have
> traces.
>=20
> If you are interested in other tests, please let me know.

How about adding the following in "[filesystem0]" to age the filesystem=
:

        agefs=3D1
        [threadgroup0]
                num_threads=3D10
                write_size=3D40960
                write_blocksize=3D4096
                create_weight=3D10
                append_weight=3D10
                delete_weight=3D1
        [end0]
                desired_util=3D0.80

This will age the filesystem until it reaches 80% utilization before
starting the benchmark.  Since a 5TB disk will take a while to age, I
suggest trying this on just a few runs.

>=20
>    Val=C3=A9rie
>=20

-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
