From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Tue, 17 Jun 2008 11:42:36 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
References: <18563.1213215457@alphaville.zko.hp.com>
 <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker>
 <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:37123 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYFQLmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2008 07:42:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by node5.dwd.de (Postfix) with ESMTP id 17B6B330361
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 11:42:44 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node5.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 28553-44 for <linux-ext4@vger.kernel.org>;
	Tue, 17 Jun 2008 11:42:43 +0000 (UTC)
In-Reply-To: <20080616181353.GA20686@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 16 Jun 2008, Aneesh Kumar K.V wrote:

> On Mon, Jun 16, 2008 at 07:54:08PM +0200, Jan Kara wrote:
>>> On Thu, 12 Jun 2008, Holger Kiehl wrote:
>>>
>>>> On Thu, 12 Jun 2008, Aneesh Kumar K.V wrote:
>>>>
>>>>> On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
>>>>>> This time there is no OOPS and system is still up running without any
>>>>>> problem (except any process wanting to write something to this filesystem
>>>>>> gets stuck forever).
>>>>>>
>>>>>> What can I do to help find the problem? The system is still up with all
>>>>>> those
>>>>>> process hanging in D-state.
>>>>>>
>>>>>
>>>>> if you can login to the system get the dmesg output after
>>>>>
>>>>> echo t > /proc/sysrq-trigger
>>>>>
>>>> Unfortunately I have not set CONFIG_MAGIC_SYSRQ. Tomorrow I will try to
>>>> reproduce this with a kernel that has CONFIG_MAGIC_SYSRQ set.
>>>>
>>> After recompiling, rebooting and run afdbench first I got an OOPS and the
>>> system hanged up solid. The only thing I was able to catch is this:
>>>
>>>   RIP [<ffffffff803019f9>] jbd2_journal_release_jbd_inode+0xcb/0x100
>>>   RSP <ffff8101fe259c18>
>>>
>>> This was copied by hand. And this I cut 'cut and past' from my terminal:
>>>
>>> kernel: Code: c3 e8 31 ce f3 ff 41 fe 04 24 e8 fe 3f 16 00 4c 89 fe 48 89
>>> df e8 5f cd f3 ff eb 82 48 83 7d 00 00 74 27 48 8b 55 10 48 8b 45 18 <48>
>>> 89 42 08 48 89 10 48 c7 45 18 00 02 20 00 48 c7 45 10 00 01
>>   Aneesh found cause of this oops I think... Aneesh, would you send the
>> fix to Holger? Thanks.
>>
>
> That fix was mainly done with the help of Holger. Many thanks to him for
> doing multiple test during weekend with different combination. He had
> already confirmed that the fix worked for me.
>
> There is another issue that he is hitting when running the test with
> mke2fs -m 0. But I think that is not related to lock inversion.
>
Doing several test with '-m 0' I was unable to reproduce this and I could
now do several runs with afdbench. However the results do show that with
ext4-patch-queue it actually slower:

For ext3:             5449.76 files per second 15.58 MiB/s
For ext4:             5162.16 files per second 15.48 MiB/s
For ext4+patch-queue: 4963.6975 files per second 14.73 MiB/s

On the positive side the bonnie++ numbers got much better:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext3            16G 51501  97 210601 91 100479 32 55528  98 301589 44  1198   5
                 16G 52702  98 215540 94 99339  32 55376  97 300933 44  1159   4
                 16G 52426  99 212584 94 99091  31 55656  98 301669 44  1160   4
ext4            16G 52965  98 224199 89 108440 32 56389  99 303792 42  1526   4
                 16G 52792  98 223980 92 107685 32 56350  98 303066 42  1532   4
                 16G 52994  98 222354 92 107802 32 56386  99 303727 41  1455   4
ext4(patchqueue)16G 59727  98 252733 52 110177 25 55821  98 296739 42  1553   5
                 16G 61047  99 239242 48 111664 25 55706  98 297151 42  1545   4
                 16G 60503  99 241532 47 109655 25 55671  98 297648 42  1552   3

ext3 and ext4 tests where done with 2.6.25.4 and those with patch-queue was
2.6.26-rc5. I will do another test run with 2.6.26-rc5 without patch-queue
just to make sure that the slowdown does not happen due to changes in the
2.6.26 branch.

Another important observation is that ext4+patch-queue does still have the
same error I reported 2 years ago, see:
     http://marc.info/?l=linux-ext4&m=115192918624449&w=2

During afdbench the results are written to $HOME/results, see the following
listing before running afdbench:

    afdbench@helena:~/results$ ls -ltr
    total 260
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 09:40 results.10740.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1320 2008-05-26 09:47 results.15132.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1593 2008-05-26 10:03 results.20899.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1499 2008-05-26 10:20 results.30577.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1319 2008-05-26 10:33 results.9819.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 10:40 results.16657.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 10:48 results.21319.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 10:59 results.25168.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 11:05 results.29113.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 11:15 results.1626.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 11:47 results.6247.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 11:53 results.10889.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 12:09 results.8970.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench   838 2008-05-26 12:22 results.2635.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1281 2008-05-26 12:35 results.2686.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1327 2008-05-26 12:43 results.7525.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1693 2008-05-26 12:56 results.13665.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1600 2008-05-26 13:15 results.23610.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1600 2008-05-26 15:10 results.13041.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1604 2008-05-26 15:23 results.22862.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1604 2008-05-26 15:43 results.32516.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14582 2008-05-28 17:16 results.2585.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14583 2008-05-28 20:17 results.32490.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14628 2008-05-28 23:19 results.11812.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14845 2008-05-29 02:22 results.31472.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 21134 2008-05-29 05:30 results.27636.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 21970 2008-05-29 08:40 results.25944.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  3309 2008-05-29 11:11 results.14789.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  3310 2008-05-29 11:43 results.20842.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4107 2008-06-16 21:45 results.2190.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4108 2008-06-16 23:04 results.8794.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4108 2008-06-17 00:22 results.27273.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4109 2008-06-17 01:41 results.4505.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  8450 2008-06-17 03:05 results.19995.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  9230 2008-06-17 04:35 results.24033.helena.dwd.de

And here is the listing after running the benchmark:

    afdbench@helena:~/results$ ls -ltr
    total 284
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 09:40 results.10740.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1320 2008-05-26 09:47 results.15132.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1593 2008-05-26 10:03 results.20899.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1499 2008-05-26 10:20 results.30577.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1319 2008-05-26 10:33 results.9819.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 10:40 results.16657.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 10:48 results.21319.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 10:59 results.25168.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 11:05 results.29113.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 11:15 results.1626.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 11:47 results.6247.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1273 2008-05-26 11:53 results.10889.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1274 2008-05-26 12:09 results.8970.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench   838 2008-05-26 12:22 results.2635.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1281 2008-05-26 12:35 results.2686.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1327 2008-05-26 12:43 results.7525.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1693 2008-05-26 12:56 results.13665.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1600 2008-05-26 13:15 results.23610.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1600 2008-05-26 15:10 results.13041.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1604 2008-05-26 15:23 results.22862.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  1604 2008-05-26 15:43 results.32516.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14582 2008-05-28 17:16 results.2585.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14583 2008-05-28 20:17 results.32490.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14628 2008-05-28 23:19 results.11812.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 14845 2008-05-29 02:22 results.31472.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 21134 2008-05-29 05:30 results.27636.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench 21970 2008-05-29 08:40 results.25944.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  3309 2008-05-29 11:11 results.14789.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  3310 2008-05-29 11:43 results.20842.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4107 2008-06-16 21:45 results.2190.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4108 2008-06-16 23:04 results.8794.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4108 2008-06-17 00:22 results.27273.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  4109 2008-06-17 01:41 results.4505.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  8450 2008-06-17 03:05 results.19995.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  8208 2008-06-17 04:35 results.24033.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  8361 2008-06-17 08:19 results.9628.helena.dwd.de
    -rw-r--r-- 1 afdbench afdbench  8858 2008-06-17 09:49 results.8134.helena.dwd.de

Note how the size of file results.24033.helena.dwd.de changes from 9230 before
the test to 8208 bytes after the test. Also note the date both have the same
timestamp "2008-06-17 04:35". I have made a copy of results.24033.helena.dwd.de
before the test and compared it with that after the test. The file is just
truncated by 1022 bytes and there is no garbage.

This is reproducible but not always, sometimes only a small part gets truncated
and sometimes several kilobytes get truncated.

Holger

