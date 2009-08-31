From: Andreas Dilger <adilger@sun.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 17:16:44 -0600
Message-ID: <20090831231644.GK4197@webber.adilger.int>
References: <4A9BFB88.5030409@redhat.com>
 <20090831201932.GD4197@webber.adilger.int> <4A9C3A30.5060401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Ted Ts'o" <tytso@thunk.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49038 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZHaXQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 19:16:43 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7VNGkeW029453
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:16:46 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP900000KABHX00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 31 Aug 2009 16:16:46 -0700 (PDT)
In-reply-to: <4A9C3A30.5060401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  17:01 -0400, Ric Wheeler wrote:
> On 08/31/2009 04:19 PM, Andreas Dilger wrote:
>> Ouch, 4h is a long time, but hopefully not many people have to reformat
>> their 120TB filesystem on a regular basis.
>
> Seems that it should not take longer than fsck in any case? Might be 
> interesting to use bkltrace/seekwatcher to see if it is thrashing these 
> big, slow drives around...

Well, e2fsck + gdt_csum can skip reading large parts of an empty
filesystem, while ironically mke2fs is required to initialize it all.

>>> [root@megadeth e2fsck]# time ./e2fsck -f -tt /dev/vg_wdc_disks/lv_wdc_disks
>>> e2fsck 1.41.8 (20-Jul-2009)
>>> Pass 1: Checking inodes, blocks, and sizes
>>> Pass 1: Memory used: 1280k/18014398508273796k (1130k/151k), time:
>>> 4630.05/780.40/3580.01
>>
>> Sigh, we need better memory accounting in e2fsck.  Rather than depending
>> on the VM/glibc to track that for us, how hard would it be to just add
>> a counter into e2fsck_{get,free,resize}_mem() to track this?
>
> That second number looks like a bug, not a real memory number. The 
> largest memory allocation I saw while it ran with top was around 6-7GB 
> iirc.

Sure, it is a 32-bit overflow (which is the most this API can provide),
which is why we should fix it.

>> Hmm, is e2fsck computing the 64-byte group descriptor checksum differently
>> than the kernel?  Can we dump the group descriptors before and after the
>> e2fsck run to see whether they have been modified without any messages to
>> the console?
>
> I tried to verify that by redoing a shorter run with fs_mark, 
> unmount/remount (no fsck in the middle).
>
> That file system remounted with no corrupted group descriptors.
>
> Running fsck on it & remounting reproduces the error (although, again, no 
> fixes reported during the run).
>
> Running fsck on it after the first corruption did indeed fix it & I could remount.
>
> Do you have a specific debugfs/other command I should use to poke at it with?

Getting dumps of the corrupted group descriptors before/after corruption,
to see what the values are, per my other email.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

