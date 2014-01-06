From: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: AW: ext4 filesystem bad extent error review
Date: Mon, 6 Jan 2014 13:17:37 +0800
Message-ID: <AE39A478622CF340ABEC2418D74074F61FC59ACC8A@SGPMBX05.APAC.bosch.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com>
 <52C6F28A.6060706@redhat.com>
 <B8A948099C53E0408BDBCE749AAECA9A2A80C78551@SI-MBX10.de.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:59348 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaAFFRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jan 2014 00:17:50 -0500
In-Reply-To: <B8A948099C53E0408BDBCE749AAECA9A2A80C78551@SI-MBX10.de.bosch.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



>On Thu, Jan 03, 2014 at 19:24, Eric Sandeen wrote
>> 
>> On 1/3/14, 10:29 AM, Juergens Dirk (CM-AI/ECO2) wrote:
>> > So, I think there _might_ be a kernel bug, but it could be also a
>> problem
>> > related to the particular type of eMMC. We did not observe the same
>> issue
>> > in previous tests with another type of eMMC from another supplier,
>> but this
>> > was with an older kernel patch level and with another HW design.
>> >
>> > Regarding a possible kernel bug: Is there any chance that the invalid
>> > ee_len or ee_start are returned by, e.g., the block allocator ?
>> > If so, can we try to instrument the code to get suitable traces ?
>> > Just to see or to exclude that the corrupted inode is really written
>> > to the eMMC ?
>> 
>> From your description it does sound possible that it's a kernel bug.
>> Adding testcases to the code to catch it before it hits the journal
>> might be helpful - but then maybe this is something getting overwritten
>> after the fact - hard to say.
>> 
>> Can you share more details of the test you are running?  Or maybe even
>> the test itself?

>Yes, for sure, we can. Weller, please provide additional details
>or corrections. 

>In short:
>Basically we use an automated cyclic test writing many small 
> (some kBytes) files with CRC checksums for easy consistency check
>into a separate test partition. Files also contain meta information
>like filename,  sequence number and a random number to allow to identify 
>from block device image dumps, if we just see a fragment of an old
>deleted file or a still valid one. 

>Each test loop looks like this:
>1) Boot the device after power on or reset
>2) Do fsck -n BEFORE mounting
>2 a) (optional) binary dump of the journal 
>3) Mount test partition
>4) File content check for all files from prev. loop
>5) erase all files from previous loop
>6) start writing hundreds/thousands of test files 
>   in multiple directories with several threads
>7) after random time cut the power or do soft reset

>If 2), 3), 4) or 5) fails, stop test.

>We are running the test usually with kind of transaction
>safe handling, i.e. use fsync/rename, to avoid zero length files
>or file fragments.

Yes, Dirk's description is right.
And You also can get the detail of my test in the package code_out.tar.gz in another mail.  There is a document to introduce my test tool and test case.
And also the test scripts.


Thanks.

Huang weller
