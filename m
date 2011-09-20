From: torn5 <torn5@shiftmail.org>
Subject: Re: What to put for unknown stripe-width?
Date: Tue, 20 Sep 2011 17:29:34 +0200
Message-ID: <4E78B15E.9060702@shiftmail.org>
References: <4E786B53.5020407@shiftmail.org>
 <9D3B900A-8FCF-41B1-852A-FADD953FBDBD@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:56753 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1ITP36 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 11:29:58 -0400
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x5 #31918)
 with ESMTPSA id <01O6A8TIZXOCXPMQ8Y@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Tue, 20 Sep 2011 17:29:34 +0200 (MEST)
In-reply-to: <9D3B900A-8FCF-41B1-852A-FADD953FBDBD@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/20/11 14:47, Theodore Tso wrote:
> But that's OK, because I don't know of any RAID array that supports 
> this kind of radical surgery in parameters in the first case. :-)

Ted, thanks for your reply,

Linux MD raid supports this, it's called reshape. Most parameters 
changes are supported, in particular the addition of a new disk and 
restriping of a raid5 is supported *live*. It's not very stable though...

But apart from the MD live reshape/restripe, what I could do more likely 
is to move such filesystem *live* across various RAIDs I have, 
leveraging LVM's "pvmove". Such RAIDs are almost all of 1MB stride, but 
with various number of elements, hence they have a different stripe-width.


> The other thing to consider is small writes.   If you are doing small writes, a large stripe size is a disaster, because a 32k random write by a program like MySQL will turn into a 3MB read + 3MB write request.

No this is not correct, for MD at least.
MD uses strips to compute parity, which are always 4k wide for each 
device. The reads in your example would be 32k read from two devices, 
followed by 32k write to two devices. I am testing this now with iostat 
to confirm what I'm saying with a dd 4k write: I see various spurious 
read and writes (probably due to MD and LVM accounting, dirty flags etc) 
which sum up to about 108k read and 18k write (that's the aggregated sum 
from all drives) for a single 4k write to the MD device. That's 
definitely not as large as even a single chunk which is 1MB.
What chunksize does is to regulate every how much data the placement of 
parity is changed (i.e. your ascii-art picture was correct). Large 
chunksize like I use, means that reads smaller than 1MB hopefully come 
from 1 spindle only. This is useful for us.


So, regarding my original problem, the way you use stride-size in ext4 
is that you begin every new file at the start of a stripe?

For growing an existing file what do you do, do you continue to write it 
from where it was, without holes, or you put a hole, select a new 
location at the start of a new stripe and start from there?

Regarding multiple very small files wrote together by pdflush, what do 
they do? They are sticked together on the same stripe without holes, or 
each one goes to a different stripe?

Is the change of stripe-width with tune2fs supported on a live, mounted 
fs? (I mean maybe with a mount -o remount but no umount)

Thanks for your help,

T.
