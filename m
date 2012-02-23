From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Mkfs option to choose where metadata will be stored
Date: Wed, 22 Feb 2012 21:46:36 -0700
Message-ID: <6AB3DDB3-4AAB-4F2E-8F8B-BC7F96378D9C@dilger.ca>
References: <4F44EBA0.5090606@robertoragusa.it> <83247E23-F941-4E35-9D38-395A4715E383@gmail.com> <4F4568A6.8020301@robertoragusa.it>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roberto Ragusa <mail@robertoragusa.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:14059 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2BWEqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Feb 2012 23:46:11 -0500
In-Reply-To: <4F4568A6.8020301@robertoragusa.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-22, at 15:13, Roberto Ragusa <mail@robertoragusa.it> wrote:
> On 02/22/2012 05:54 PM, Andreas Dilger wrote:
>> On 2012-02-22, at 6:20, Roberto Ragusa <mail@robertoragusa.it> wrote:
>> 
>>> My idea is to have metadata on SSD and data on HDD.
>>> With a linear RAID mapping, I would get a device which is a few GB of
>>> SSD followed by a lot of HDD space.
>> 
>> I've tested something similar to this myself. The way I did it is to use the "flex_bg" option "-G 256" to put the metadata into a single 128MB group, which is allocated on an SSD LVM PV, then 255 x 128MB on an HDD PV.
> 
> I actually discovered flex_bg a few minutes after sending my mail. :-)
> I tested -G 1048576 (that is "infinity") and played a little
> with -i to keep down the SSD usage (my current average filesize
> is 3MB, so I can have a big value), discovering that the bitmaps are
> in any case dominant.
> 
>> This pattern repeats for the entire LV size, and can easily be created with a 128MB LV on the SSD then alternating pvextend of (255 * 128MB) on the HDD PV and 128MB on the SSD PV until the desired size is reached or you run out of space on one of the PVs. 
> 
> This is a nice trick. I was thinking about only one big initial metadata zone, but
> your approach will give me back lvextend (which is useful on terabyte-range filesystems).

Exactly. And the pattern is constant until 16TB, so it can be used for any size filesystem.

>> The exact formatting options I used are:
>> 
>> mke2fs -t ext4 -i 69905 -G 256 -E resize=4290772992 {dev}
>> 
>> this will lay everything out on the LV nicely. Note that it assumes an average  file size of about 69kB here. Increasing this is fine, but making it smaller would disrupt the layout. 
> 
> You really tuned -i to perfection. :-)

Along with the resize option it aligns all the metadata nicely on 1MB boundaries for RAID-6 HDD LUNs. 

The resize trick won't work past 16TB, however, and the metadata size is also different. 

> It sounds very interesting that you only get 1/256 metadata overhead,
> because my tests were around 1/10 (which surely appears a lot!).
> I just discovered that -G 1048576 allocates a lot of expansion space, even if
> you set -E resize to a reasonable value.
> (delete my previous sentence about bitmaps :-) )
> 
> Your refinements turned my bizarre idea into a really nice solution, I'm looking
> forward to implementing it in production.
> Even a tiny SSD can take metadata for a lot of HDD disk space.

Yes, only 1/255 of the total size needs to be SSD.

> Maybe I will put
> a couple of SSD in RAID-1 as I'm still not confident about their robustness.
> (the data is backupped, in any case).

Definitely prudent. 

> One last thing: you didn't worry about the journal. What would you suggest?
> Using an external journal appears a little dirty, maybe we could just force
> it to live in the second 128MB extent and place that one on the SSD too.
> Can this be done?

I looked Into this once, and it would be desirable to have a mke2fs option to specify the starting journal block. I can't remember why I didn't finish it, but it wasn't very complex if you wanted to give it a shot. 

> Really thank you.
> 
> (this should be indeed better documented; it can have dramatic performance
> implications and some optimized parameters or a spreadsheet or web form to
> calculate them would be useful to a wider audience [I mean guys which
> are not ready to use dumpe2fs to reverse engineer the layout like I did]).

Ideally it would be built into mke2fs.

Cheers, Andreas