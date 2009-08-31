From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 17:01:36 -0400
Message-ID: <4A9C3A30.5060401@redhat.com>
References: <4A9BFB88.5030409@redhat.com> <20090831201932.GD4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@thunk.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZHaVAO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 17:00:14 -0400
In-Reply-To: <20090831201932.GD4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/31/2009 04:19 PM, Andreas Dilger wrote:
> On Aug 31, 2009  12:34 -0400, Ric Wheeler wrote:
>> We have put together a very large, relatively slow JBOD to test
>> scalability with (big server, 40GB of DRAM, 8 CPU's + 4 SAS expansion
>> shelves, each with 16 2TB WD S-ATA drives).
>>
>> In all, this is pulled together with DM (striped) to give us a bit over
>> 116TB.
>>
>> Testing was done on 2.6.31-rc6 along with the pu branches e2fsprogs.
>>
>> Everything went well until after the fsck - I think that I have
>> reproduced that earlier issue with a failed mount.
>>
>> mkfs took a very long time - longer than fsck. fsck (with around 500
>> million 20KB files) finished in just under 2 hours.
>
> Fixing the kernel to do the "safe zeroing of inode table blocks" would
> allow mke2fs to be MUCH faster than it is today...
>
>> real    230m6.362s
>> user    2m30.844s
>> sys    200m1.002s
>
> Ouch, 4h is a long time, but hopefully not many people have to reformat
> their 120TB filesystem on a regular basis.

Seems that it should not take longer than fsck in any case? Might be interesting 
to use bkltrace/seekwatcher to see if it is thrashing these big, slow drives 
around...

>
>> [root@megadeth e2fsck]# time ./e2fsck -f -tt /dev/vg_wdc_disks/lv_wdc_disks
>> e2fsck 1.41.8 (20-Jul-2009)
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 1: Memory used: 1280k/18014398508273796k (1130k/151k), time:
>> 4630.05/780.40/3580.01
>
> Sigh, we need better memory accounting in e2fsck.  Rather than depending
> on the VM/glibc to track that for us, how hard would it be to just add
> a counter into e2fsck_{get,free,resize}_mem() to track this?

That second number looks like a bug, not a real memory number. The largest 
memory allocation I saw while it ran with top was around 6-7GB iirc.

>
>> REMOUNT:
>>
>> [root@megadeth e2fsck]# mount  /dev/vg_wdc_disks/lv_wdc_disks /test_fs/
>> mount: wrong fs type, bad option, bad superblock on
>> /dev/mapper/vg_wdc_disks-lv_wdc_disks,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so
>>
>> [root@megadeth ~]# tail -20 /var/log/messages
>> <snip>
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):
>> ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
>> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors
>> corrupted!
>
> Hmm, is e2fsck computing the 64-byte group descriptor checksum differently
> than the kernel?  Can we dump the group descriptors before and after the
> e2fsck run to see whether they have been modified without any messages to
> the console?
>
> Cheers, Andreas

I tried to verify that by redoing a shorter run with fs_mark, unmount/remount 
(no fsck in the middle).

That file system remounted with no corrupted group descriptors.

Running fsck on it & remounting reproduces the error (although, again, no fixes 
reported during the run).

Running fsck on it after the first corruption did indeed fix it & I could remount.

Do you have a specific debugfs/other command I should use to poke at it with?

Thanks!

Ric



