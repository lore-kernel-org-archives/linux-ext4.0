From: bryan.coleman@dart.biz
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Tue, 8 Feb 2011 13:50:32 -0500
Message-ID: <OF0792030A.13D80D43-ON85257831.0066ABF1-85257831.006780FD@dart.biz>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz> <20110207225436.GG3457@thunk.org> <OF1BE984CE.39437668-ON85257831.00491D12-85257831.0049261D@dart.biz> <OF3CD75888.312195E5-ON85257831.0050CD2F-85257831.0051875E@dart.biz> <4D515F0D.1030902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org,
	"Ted Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from comns1.dartcontainer.com ([173.241.223.201]:2299 "EHLO
	MAS-NS06.dartcontainer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755233Ab1BHSuf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 13:50:35 -0500
In-Reply-To: <4D515F0D.1030902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found that the promise array had been restarted via watchdog timer.  I 
am investigating that avenue via promise (albeit slow).  Note: the 
watchdog reset the controller days after the initial ext4 messages.  I'm 
not saying they are unrelated.  I just what to get all of the facts out 
there.

I suspect the connection between the server and the promise got hosed when 
the controller was reset.  When I restart the server, I could fsck the 
drive.

The fsck is currently running (and has been for some time now). 

It is doing a ton of "Inode ######## ref count is 2, should be 1.  Fix? 
yes"  "Unattached inode #########"  "Connect to /lost+found? yes"

I am running fsck in a script session; however, there are currently a ton 
of the messages above (current log size: 106M).

Do you think it is still hardware?  If so, is there a command that would 
stress it enough to break quickly?  What is the best way to isolate 
hardware problems?

Bryan



From:   Eric Sandeen <sandeen@redhat.com>
To:     bryan.coleman@dart.biz
Cc:     linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>
Date:   02/08/2011 10:21 AM
Subject:        Re: ext4 problems with external RAID array via SAS 
connection
Sent by:        linux-ext4-owner@vger.kernel.org



On 2/8/11 8:50 AM, bryan.coleman@dart.biz wrote:
> Well, I attempted to run fsck on the problem drive using the script 
> command to capture the transcript; however, it failed to read a block 
from 
> the file system.  The exception was "fsck.ext4: Attempt to read block 
from 
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
> Since it looks like I need to start the process all over again, is there 
a 
> good way to quickly determine if the problem is hardware related?  Is 
> there a preferred method that will stress test the drive and shed more 
> light on what might be going wrong?

You have a hardware problem... "Buffer I/O error on device dm-2, logical 
block 0"
means that you failed to read the first block on that device; not 
something
e2fsck can fix, I'm afraid; you'll need to sort out what's wrong with the 
storage,
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
> errors.  I do not have a copy of that fsck transcript; however, I have 
not 
> 
> yet run fsck since my second attempt.  Is there a method of capturing 
the 
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
>> At first, the drive seemed to work fine.  I was primarily copying 
things 
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
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


