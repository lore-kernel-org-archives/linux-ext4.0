From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Tue, 08 Feb 2011 09:19:41 -0600
Message-ID: <4D515F0D.1030902@redhat.com>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz> <20110207225436.GG3457@thunk.org> <OF1BE984CE.39437668-ON85257831.00491D12-85257831.0049261D@dart.biz> <OF3CD75888.312195E5-ON85257831.0050CD2F-85257831.0051875E@dart.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
To: bryan.coleman@dart.biz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab1BHPTt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Feb 2011 10:19:49 -0500
In-Reply-To: <OF3CD75888.312195E5-ON85257831.0050CD2F-85257831.0051875E@dart.biz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/8/11 8:50 AM, bryan.coleman@dart.biz wrote:
> Well, I attempted to run fsck on the problem drive using the script 
> command to capture the transcript; however, it failed to read a block from 
> the file system.  The exception was "fsck.ext4: Attempt to read block from 
> filesystem resulted in short read while trying to open 
> /dev/mapper/vg_storage-lv_storage". 
> 
> Other messages that are now in /var/log/messages:
> 
> Buffer I/O error on device dm-2, logical block 0
> lost page write due to I/O error on dm-2
> EXT4-fs (dm-2): previous I/O error to superblock detected
> Buffer I/O error on device dm-2, logical block 0
> lost page write due to I/O error on dm-2
> Buffer I/O error on device dm-2, logical block 0
> Buffer I/O error on device dm-2, logical block 1
> Buffer I/O error on device dm-2, logical block 2
> Buffer I/O error on device dm-2, logical block 3
> Buffer I/O error on device dm-2, logical block 0
> EXT4-fs (dm-2): unable to read superblock
> 
> 
> Since it looks like I need to start the process all over again, is there a 
> good way to quickly determine if the problem is hardware related?  Is 
> there a preferred method that will stress test the drive and shed more 
> light on what might be going wrong?

You have a hardware problem... "Buffer I/O error on device dm-2, logical block 0"
means that you failed to read the first block on that device; not something
e2fsck can fix, I'm afraid; you'll need to sort out what's wrong with the storage,
first.

-Eric

> Thank you,
> 
> Bryan
> 
> 
> 
> From:   bryan.coleman@dart.biz
> To:     linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org
> Date:   02/08/2011 08:19 AM
> Subject:        Re: ext4 problems with external RAID array via SAS 
> connection
> Sent by:        linux-ext4-owner@vger.kernel.org
> 
> 
> 
> When I ran fsck after the first bout of failure, it did report a lot of 
> errors.  I do not have a copy of that fsck transcript; however, I have not 
> 
> yet run fsck since my second attempt.  Is there a method of capturing the 
> transcript that is preferred?
> 
> Bryan
> 
> 
> 
> From:   Ted Ts'o <tytso@mit.edu>
> To:     bryan.coleman@dart.biz
> Cc:     linux-ext4@vger.kernel.org
> Date:   02/07/2011 05:55 PM
> Subject:        Re: ext4 problems with external RAID array via SAS 
> connection
> Sent by:        linux-ext4-owner@vger.kernel.org
> 
> 
> 
> On Mon, Feb 07, 2011 at 01:53:18PM -0500, bryan.coleman@dart.biz wrote:
>> I am experiencing problems with an ext4 file system.
>>
>> At first, the drive seemed to work fine.  I was primarily copying things 
> 
> 
>> to the drive migrating data from another server.  After many GBs of 
> data, 
>> that seemingly successfully were done being transferred, I started 
> seeing 
>> ext4 errors in /var/log/messages.  I then unmounted the drive and ran 
> fsck 
>> on it (which took multiple hours to run).  I then ls'ed around and one 
> of 
>> the areas caused the system to again throw ext4 errors.
> 
> Did fsck report any errors?  Do you have a copy of your fsck
> transcript?
> 
> The errors you've reported do make me suspicious that there's
> something unstable with your hardware...
> 
>   - Ted
> --
