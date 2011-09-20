From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What to put for unknown stripe-width?
Date: Tue, 20 Sep 2011 08:47:01 -0400
Message-ID: <9D3B900A-8FCF-41B1-852A-FADD953FBDBD@mit.edu>
References: <4E786B53.5020407@shiftmail.org>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:45773 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab1ITMq7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Sep 2011 08:46:59 -0400
In-Reply-To: <4E786B53.5020407@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sep 20, 2011, at 6:30 AM, torn5 wrote:

> Hello there,
> I am planning some ext4 filesystems which are currently in (LVM over) a RAID array having:
> 
> stride=1MiB   stripe-witdth=4MiB
> 
> BUT ... their RAID could be enlarged with more disks in the future and/or they are likely to be moved around live (leveraging LVM, which I will align) to other RAIDs which also will have stride=1MiB but unknown, as of now, stripe-width.
> That's on HDDs, with platters.

You can't change the stride width without essentially recreating the RAID system.   Let's assume you're doing RAID 5 with four disks.   Then the picture looks like this:

       DISK A                DISK B                 DISK C                 DISK D
| --- chunk 0 ---|  | --- chunk 1 ---|  | --- chunk  2 ---|  | ---  Parity     ---|  
| --- chunk 3 ---|  | --- chunk 4 ---|  | ---  Parity     ---|  | --- chunk 5  ---| 
| --- chunk 6 ---|  | ---  Parity    ---|  | --- chunk  7 ---|  | --- chunk 8  ---|  
| ---   Parity   ---|  | --- chunk 9 ---|  | --- chunk 10 --|  | --- chunk 11---| 

Each of the chunks are 1MB, and the stripe size is 3MB.     But if you add a new hypothetical disk E, you can't just add it next to Disk D, because then you'd have to renumber all of the chunks.  Instead you might add Disks F, G, and H as well, and then tack them on to the end of the disks A, B, C, and D.   But the stripe size stays the same without some serious surgery.    But even if you did the surgery, there's the problem of what to do with the file system.

Why does the file system care about the RAID parameters?   Well, suppose you do a 1MB write to replace chunk #0.   You will also need to read chunks #1 and #2 so you can calculate the parity chunk on disk D.   This is called a read/modify/write cycle, and it's inefficient.    To avoid that, you need to do writes which are aligned on the stripe, and sized for the stripe.   So for the best file system performance, the file system should align its files so that they begin at the beginning of a RAID stripe.  So even if you could change the parameters of your RAID array (which would require radical surgery involving lots of data movement), the file system would also need to be changed to support optimized writes on the new stripe size.   But that's OK, because I don't know of any RAID array tha
 t supports this kind of radical surgery in parameters in the first case.  :-)

The other thing to consider is small writes.   If you are doing small writes, a large stripe size is a disaster, because a 32k random write by a program like MySQL will turn into a 3MB read + 3MB write request.  Large stripe sizes are good for sequential writes of large files, but not so much for small random writes.

										- Ted



