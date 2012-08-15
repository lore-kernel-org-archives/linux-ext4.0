From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro filesystem
Date: Wed, 15 Aug 2012 12:25:15 -0500
Message-ID: <502BDB7B.6030404@redhat.com>
References: <500F1C28.8010800@redhat.com> <20120815121403.GA29223@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab2HORZV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2012 13:25:21 -0400
In-Reply-To: <20120815121403.GA29223@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/15/12 7:14 AM, Jan Kara wrote:
> On Tue 24-07-12 17:05:28, Eric Sandeen wrote:
>> This sequence:
>>
>> # truncate --size=65536 fsfile
>> # losetup --offset 65536 /dev/loop0 fsfile
>> # mkfs.ext4 /dev/loop0
>> # losetup -d /dev/loop0
>> # mount -o loop,ro,offset=65536 fsfile  mnt/
>> # umount mnt
>> # dmesg | tail
>>
>> results in an IO error when unmounting the RO filesystem:
>>
>> [  312.386074] SELinux: initialized (dev loop1, type ext4), uses xattr
>> [  318.020828] Buffer I/O error on device loop1, logical block 196608
>> [  318.027024] lost page write due to I/O error on loop1
>> [  318.032088] JBD2: Error -5 detected when updating journal superblock for loop1-8.
>    Ted, did this patch fall through cracks? I've ported the fix to JBD and
> added it to my tree. I plan to send it to Linus in a few days. Also I've
> CC'd stable since this is a bit annoying regression.
>
> 								Honza


Thanks for doing both of those things, Jan.

BTW this happens on loop because mount -o,ro apparently sets up the loop 
device itself as readonly.

-Eric
