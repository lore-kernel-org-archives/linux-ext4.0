From: Valerie Clement <valerie.clement@bull.net>
Subject: Test results for ext4
Date: Fri, 30 May 2008 17:50:43 +0200
Message-ID: <48402253.8040407@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming Cao <cmm@us.ibm.com>, "Jose R. Santos" <jrs@us.ibm.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36848 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYE3PvV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 11:51:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Since a couple of weeks, I did batches of tests to have some performanc=
e
numbers for the new ext4 features like uninit_groups, flex_bg or
journal_checksum on a 5TB filesystem.
I tried to test allmost all combinations of mkfs and mount options, but
I put only a subset of them in the result tables, the most significant
for me.

I had started to do these tests on a kernel 2.6.26-rc1, but I'd got sev=
eral
hangs and crashes occuring randomly outside ext4, sometimes in the slab
code or in the scsi driver eg., and which were not reproductible.
Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.

The first results and the test description are available here:
http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.h=
tml

I will complete them in the next days.

In the first batch of tests, I compare the I/O throughput to create
1-GB files on disk in different configurations. The CPU usage is also
given to show mainly how the delayed allocation feature reduces it.
The average number of extents per file shows the impact of the
multiblock allocator and the flex_bg grouping on the file fragmentation=
=2E
At last, the fsck time shows how the uninit_groups feature reduces the
e2fsck duration.

In the second batch of tests, the results show improvements in transact=
ions
-per-second throughput when doing small files writes, reads and creates
when using the flex_bg grouping.
The same ffsb test on an XFS filesystem hangs, I will try to have trace=
s.

If you are interested in other tests, please let me know.

   Val=E9rie


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
