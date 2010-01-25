From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: IO error semantics
Date: Mon, 25 Jan 2010 10:23:57 -0500
Message-ID: <4B5DB78D.2090408@redhat.com>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop> <20100118122437.GF7264@discord.disaster> <20100118140039.GA13909@laptop> <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Nick Piggin <npiggin@suse.de>, Dave Chinner <david@fromorbit.com>,
	Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0AYPYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 10:24:25 -0500
In-Reply-To: <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/18/2010 06:33 PM, Anton Altaparmakov wrote:
> Hi,
>
> On 18 Jan 2010, at 14:00, Nick Piggin wrote:
>    
>> For write errors, you could also do block re-allocation, which would be fun.
>>      
> Yes it would.  (-:
>
> FWIW, Windows does this with Microsoft's NTFS driver.  When a write fails due to a bad block, the block is marked as bad (recorded in the bad cluster list and marked as allocated in the in-use bitmap so no-one tries to allocate it), a new block is allocated, inode metadata is updated to reflect the change in the logical to physical block map of the file the block belongs to, and the write is then re-tried to its new location.
>
> I have never bothered implementing it in NTFS on Linux partially because there doesn't seem any obvious way to do it inside the file system.  I think the VFS and/or the block layer would have to offer help there in some way.  What I mean for example is that if ->writepage fails then the failure is only detected inside the asynchronous i/o completion handler at which point the page is not locked any more, it is marked as being under writeback, and we are in IRQ context (or something) and thus it is not easy to see how we can from there get to doing all the above needed actions that require memory allocations, disk i/o, etc...  I suppose a separate thread could do it where we just schedule the work to be done.  But problem with that is that that work later on might fail so we can't simply 
 pretend the block was written successfully yet we do not want to report an error or the upper layers would pick it up even though we hopefully will correct it in due course...
>
> Best regards,
>
> 	Anton
>    

For permanent write errors, I would expect any modern drive to do a 
sector remapping internally. We should never need to track this kind of 
information for any modern device that I know of (S-ATA, SAS, SSD's and 
raid arrays should all handle this).

Would not seem to be worth the complexity.

Also keep in mind that retrying IO errors is not always a good thing - 
devices retry failed IO multiple times internally. Adding additional 
retry loops up the stack only makes our unavoidable IO error take much 
longer to hit!

Ric


