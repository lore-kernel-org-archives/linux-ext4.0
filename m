From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Test results for ext4
Date: Mon, 02 Jun 2008 22:14:39 -0500
Message-ID: <4844B71F.3070906@redhat.com>
References: <48402253.8040407@bull.net> <4841A871.3020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	"Jose R. Santos" <jrs@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYFCD1y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 23:27:54 -0400
In-Reply-To: <4841A871.3020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Valerie Clement wrote:
>> Hi all,
>>
>> Since a couple of weeks, I did batches of tests to have some performance
>> numbers for the new ext4 features like uninit_groups, flex_bg or
>> journal_checksum on a 5TB filesystem.
>> I tried to test allmost all combinations of mkfs and mount options, but
>> I put only a subset of them in the result tables, the most significant
>> for me.
>>
>> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got several
>> hangs and crashes occuring randomly outside ext4, sometimes in the slab
>> code or in the scsi driver eg., and which were not reproductible.
>> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
>>
>> The first results and the test description are available here:
>> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
>> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
>>
> 
> One other question on the tests; am I reading correctly that ext3 used
> "data=writeback" but ext4 used the default data=ordered mode?

I was interested in the results, especially since ext3 seemed to pretty
well match ext4 for throughput, although the cpu utilization differed.

I re-ran the same ffsb profiles on an 8G, 4-way opteron box, connected
to a "Vendor: WINSYS   Model: SF2372" 2T hardware raid array with 512MB
cache, connected via fibrechannel.

Reads go pretty fast:

# dd if=/dev/sdc bs=16M count=512 iflag=direct of=/dev/null
8589934592 bytes (8.6 GB) copied, 23.2257 seconds, 370 MB/s

I got some different numbers....

This was with e2fsprogs-1.39 for ext3, e2fsprogs-1.40.10 for ext4, and
xfsprogs-2.9.8 for xfs.

I used defaults except; data=writeback for ext[34] and the nobarrier
option for xfs.  ext3 was made with 128 byte inodes, ext4 with 256-byte
(new default).  XFS used stock mkfs.  I formatted the entire block
device /dev/sdc.

For the large file write test:

	MB/s	CPU %
ext3	140	 90.7
ext4	182	 50.2
xfs	222	145.0

And for the small random readwrite test:

	trans/s	CPU %
ext3	 9830	 12.2
ext4	11996	 18.1
xfs	13863	 23.5

Not sure what the difference is ...

If you have your tests scripted up I'd be interested to run all the
variations on this hardware as well, as it seems to show more throughput
differences...

Thanks!

-Eric
