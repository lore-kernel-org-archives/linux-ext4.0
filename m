From: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 filesystem bad extent error review
Date: Mon, 6 Jan 2014 11:53:36 +0800
Message-ID: <AE39A478622CF340ABEC2418D74074F61FC59ACBC9@SGPMBX05.APAC.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
 <20140103154846.GB31411@thunk.org> <52C6F22A.4040202@redhat.com>
 <20140103175111.GA4336@thunk.org> <52C6F944.4030605@redhat.com>
 <20140103180654.GC4336@thunk.org>
 <B8A948099C53E0408BDBCE749AAECA9A2A80C7854F@SI-MBX10.de.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:58464 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaAFDyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jan 2014 22:54:11 -0500
In-Reply-To: <B8A948099C53E0408BDBCE749AAECA9A2A80C7854F@SI-MBX10.de.bosch.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>On Thu, Jan 03, 2014 at 19:07, Theodore Ts'o [mailto:tytso@mit.edu]
>wrote:
>> 
>>> On Fri, Jan 03, 2014 at 11:54:12AM -0600, Eric Sandeen wrote:
> > >
>> > > This call chain only happens if the block device is mounted.
>> >
>> > Sure, but I thought that's what they were doing.  Maybe I misread.
>> >
>> 
>> I thought this was in relation to doing what they called a "barrier
>> test", where you are writing to flash device and then drop power, and
>> then see if the CACHE FLUSH request was actually honored.  (And
>> whether or not the FTL got corrupted so badly that the device brick's
>> itself, as does happen for some of the crappier cheap flash out
>> there.)
>> 
>> But I'm not sure precisely how they implemented their test.  It's
>> possible it was done with the file system mounted.  My suggestion was
>> to make sure that the flash was proof against power drops by doing
>> this using a raw block device, to remove the variable of the file
>> system.
>> 

>Just as a quick reply for today:
>If I remember right, Weller has done the barrier test w/o file system
>mounted. Weller can give more details when he is back in office.
>However, these tests were done some while ago with another type of
>eMMC.  

My previous block device barrier test is like this:
0. power on
1. run the test program:  generate a map file on local fs. This file include a header and the many random block numbers.
2. test program pick up a block number from the map file offset N
3. generate new buffer with commit ID and random string. Write this buffer to the block(from last step).
4. set barrier.(previous use the ioctl BLKFLSBUF, it will be change to fsync later)
5.backup the buffer which generated on step 3: write it to block 0.
6. set barrier like step5. N++
7. jump to step2

The power loss or sw-reset would happen between step2 and 7 randomly.   

Below is the step to check the test results:
1. load map file. Load block number 0 to get the last commit ID and last block number.
2. search the last block number in the map file. i.e: get the last block number at map[N].
3.get the block number from map[0] to map[N-1], check the contents of these blocks. If there is a block contents error among these blocks, we can say there are some problems.

As I remember I didn't see any problem of the test at that time. But I can do same test on the same brand eMMC which we found the bad extents issue later.
Please let us know if there is any problem on our test concept. 
Thanks.
                                  -Huang weller



>> Given that they've since reported that they can repro the problem
>> using soft resets, it doesn't sound like the problem is related to
>> flash devices not handling powe drops correctly 

>I think so as well, for the same reason and also because our tests with
>journal_checksum show the same problem w/o any checksum error.

