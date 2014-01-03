From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: AW: AW: ext4 filesystem bad extent error review
Date: Fri, 03 Jan 2014 12:48:48 -0600
Message-ID: <52C70610.4010907@redhat.com>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com> <20140102184211.GC10870@thunk.org> <B8A948099C53E0408BDBCE749AAECA9A2A80C78543@SI-MBX10.de.bosch.com> <52C6F28A.6060706@redhat.com> <B8A948099C53E0408BDBCE749AAECA9A2A80C78551@SI-MBX10.de.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbaACSsy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 13:48:54 -0500
In-Reply-To: <B8A948099C53E0408BDBCE749AAECA9A2A80C78551@SI-MBX10.de.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/3/14, 12:45 PM, Juergens Dirk (CM-AI/ECO2) wrote:
>=20
> On Thu, Jan 03, 2014 at 19:24, Eric Sandeen wrote
>>
>> On 1/3/14, 10:29 AM, Juergens Dirk (CM-AI/ECO2) wrote:
>>> So, I think there _might_ be a kernel bug, but it could be also a
>> problem
>>> related to the particular type of eMMC. We did not observe the same
>> issue
>>> in previous tests with another type of eMMC from another supplier,
>> but this
>>> was with an older kernel patch level and with another HW design.
>>>
>>> Regarding a possible kernel bug: Is there any chance that the inval=
id
>>> ee_len or ee_start are returned by, e.g., the block allocator ?
>>> If so, can we try to instrument the code to get suitable traces ?
>>> Just to see or to exclude that the corrupted inode is really writte=
n
>>> to the eMMC ?
>>
>> From your description it does sound possible that it's a kernel bug.
>> Adding testcases to the code to catch it before it hits the journal
>> might be helpful - but then maybe this is something getting overwrit=
ten
>> after the fact - hard to say.
>>
>> Can you share more details of the test you are running?  Or maybe ev=
en
>> the test itself?
>=20
> Yes, for sure, we can. Weller, please provide additional details
> or corrections.=20
>=20
> In short:
> Basically we use an automated cyclic test writing many small=20
> (some kBytes) files with CRC checksums for easy consistency check
> into a separate test partition. Files also contain meta information
> like filename,  sequence number and a random number to allow to ident=
ify=20
> from block device image dumps, if we just see a fragment of an old
> deleted file or a still valid one.=20
>=20
> Each test loop looks like this:

0) mkfs the filesystem - with what options?  How big?

> 1) Boot the device after power on or reset
> 2) Do fsck -n BEFORE mounting
> 2 a) (optional) binary dump of the journal=20
> 3) Mount test partition

Again with what options, if any?

> 4) File content check for all files from prev. loop
> 5) erase all files from previous loop
> 6) start writing hundreds/thousands of test files=20
>     in multiple directories with several threads

I guess this is where we might need more details in order,
to try to recreate the failure, but perhaps
this is not a case where you can simply share the IO
generation utility...?

Thanks,
-Eric

> 7) after random time cut the power or do soft reset
>=20
> If 2), 3), 4) or 5) fails, stop test.
>=20
> We are running the test usually with kind of transaction
> safe handling, i.e. use fsync/rename, to avoid zero length files
> or file fragments.
>=20
>>
>> I've used a test framework in the past to simulate resets w/o needin=
g
>> to reset the box, and do many journal replays very quickly.  It'd be
>> interesting to run it using your testcase.
>>
>> Thanks,
>> -Eric
>=20
> Mit freundlichen Gr=FC=DFen / Best regards
>=20
> Dirk Juergens
>=20
> Robert Bosch Car Multimedia GmbH
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
