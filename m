From: Mingming <cmm@us.ibm.com>
Subject: Re: Test results for ext4
Date: Fri, 30 May 2008 10:48:32 -0700
Message-ID: <1212169712.8596.76.camel@BVR-FS.beaverton.ibm.com>
References: <48402253.8040407@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Jose R. Santos" <jrs@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:59969 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYE3Rs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 13:48:28 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4UHmRk8031889
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 13:48:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UHmNmw073658
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 11:48:24 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UHmNJ0024235
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 11:48:23 -0600
In-Reply-To: <48402253.8040407@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, 2008-05-30 at 17:50 +0200, Valerie Clement wrote:
> Hi all,
>=20

Hi Valerie,

> Since a couple of weeks, I did batches of tests to have some performa=
nce
> numbers for the new ext4 features like uninit_groups, flex_bg or
> journal_checksum on a 5TB filesystem.
> I tried to test allmost all combinations of mkfs and mount options, b=
ut
> I put only a subset of them in the result tables, the most significan=
t
> for me.
>=20

Thanks, that's very helpful.

> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got s=
everal
> hangs and crashes occuring randomly outside ext4, sometimes in the sl=
ab
> code or in the scsi driver eg., and which were not reproductible.
> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
>=20
> The first results and the test description are available here:
> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.htm=
l

Interesting nomballoc is faster than default (with mballoc) about 3%,
but the fragmentation is much better.

> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2=
=2Ehtml
>=20


> I will complete them in the next days.
>=20
> In the first batch of tests, I compare the I/O throughput to create
> 1-GB files on disk in different configurations. The CPU usage is also
> given to show mainly how the delayed allocation feature reduces it.
> The average number of extents per file shows the impact of the
> multiblock allocator and the flex_bg grouping on the file fragmentati=
on.
> At last, the fsck time shows how the uninit_groups feature reduces th=
e
> e2fsck duration.
>=20
Don't know if Jose has any suggestions, I am curious what's the impact
of flex bg alone on fsck perf?

> In the second batch of tests, the results show improvements in transa=
ctions
> -per-second throughput when doing small files writes, reads and creat=
es
> when using the flex_bg grouping.
> The same ffsb test on an XFS filesystem hangs, I will try to have tra=
ces.
>=20

> If you are interested in other tests, please let me know.
>=20
I also wondering if you get a chance to test larger inode (>256 bytes)
with uninit group and flex bg?=20

>    Val=C3=A9rie
>=20
>=20
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
