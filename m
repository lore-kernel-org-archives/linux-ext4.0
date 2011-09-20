From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: What to put for unknown stripe-width?
Date: Tue, 20 Sep 2011 17:29:53 -0600
Message-ID: <FED48113-16A4-4EBB-9A63-CABD3A759976@dilger.ca>
References: <4E786B53.5020407@shiftmail.org> <9D3B900A-8FCF-41B1-852A-FADD953FBDBD@mit.edu> <4E78B15E.9060702@shiftmail.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24175 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab1ITX34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 19:29:56 -0400
In-Reply-To: <4E78B15E.9060702@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-20, at 9:29 AM, torn5 wrote:
> On 09/20/11 14:47, Theodore Tso wrote:
>> But that's OK, because I don't know of any RAID array that supports this kind of radical surgery in parameters in the first case. :-)
> 
> Ted, thanks for your reply,
> 
> Linux MD raid supports this, it's called reshape. Most parameters changes are supported, in particular the addition of a new disk and restriping of a raid5 is supported *live*. It's not very stable though...
> 
> But apart from the MD live reshape/restripe, what I could do more likely is to move such filesystem *live* across various RAIDs I have, leveraging LVM's "pvmove". Such RAIDs are almost all of 1MB stride, but with various number of elements, hence they have a different stripe-width.

Just FYI, we use 1MB stripe width for Lustre by default, and this is large
enough for very good IO performance, and is very well tested.

>> The other thing to consider is small writes.   If you are doing small writes, a large stripe size is a disaster, because a 32k random write by a program like MySQL will turn into a 3MB read + 3MB write request.
> 
> So, regarding my original problem, the way you use stride-size in ext4 is that you begin every new file at the start of a stripe?

With ext4 and flex_bg it is nearly irrelevant.  I try to use a flex_bg size
that is -G 256 to match the stripe_width, so that the bitmap load on all the
disks is even.  It would be good to have a patch to do this by default, but
I haven't gotten around to that.

> For growing an existing file what do you do, do you continue to write it from where it was, without holes, or you put a hole, select a new location at the start of a new stripe and start from there?

Large files will be allocated at the start of the stripe_width (1MB) alignment,
and (IIRC) small files will be packed together into a 1MB chunk, to minimize
read-modify-write on the RAID.

> Regarding multiple very small files wrote together by pdflush, what do they do? They are sticked together on the same stripe without holes, or each one goes to a different stripe?

I'm not 100% sure that the small files are still being handled correctly,
since it is a long time since I looked at that code and it has undergone
a lot of changes.

> Is the change of stripe-width with tune2fs supported on a live, mounted fs? (I mean maybe with a mount -o remount but no umount)

I think it is cached in the in-memory superblock to include any mount-time
parameters and sanity checks, so I don't think it will take effect.

Cheers, Andreas





