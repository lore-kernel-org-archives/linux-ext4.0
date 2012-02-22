From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: Mkfs option to choose where metadata will be stored
Date: Wed, 22 Feb 2012 09:54:46 -0700
Message-ID: <83247E23-F941-4E35-9D38-395A4715E383@gmail.com>
References: <4F44EBA0.5090606@robertoragusa.it>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roberto Ragusa <mail@robertoragusa.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2BVQyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Feb 2012 11:54:22 -0500
Received: by daed14 with SMTP id d14so209926dae.19
        for <linux-ext4@vger.kernel.org>; Wed, 22 Feb 2012 08:54:21 -0800 (PST)
In-Reply-To: <4F44EBA0.5090606@robertoragusa.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-22, at 6:20, Roberto Ragusa <mail@robertoragusa.it> wrote:

> Hi, [please CC me, I'm not subscribed]
> 
> is there any way to force allocation of metadata to a different device
> or to a specific part (e.g. the begin) of the partition?
> 
> I see there is -O journal_dev to redirect the journal.
> Can I do something different for metadata?
> 
> My idea is to have metadata on SSD and data on HDD.
> With a linear RAID mapping, I would get a device which is a few GB of
> SSD followed by a lot of HDD space.

I've tested something similar to this myself. The way I did it is to use the "flex_bg" option "-G 256" to put the metadata into a single 128MB group, which is allocated on an SSD LVM PV, then 255 x 128MB on an HDD PV.

This pattern repeats for the entire LV size, and can easily be created with a 128MB LV on the SSD then alternating pvextend of (255 * 128MB) on the HDD PV and 128MB on the SSD PV until the desired size is reached or you run out of space on one of the PVs. 

The exact formatting options I used are:

mke2fs -t ext4 -i 69905 -G 256 -E resize=4290772992 {dev}

this will lay everything out on the LV nicely. Note that it assumes an average  file size of about 69kB here. Increasing this is fine, but making it smaller would disrupt the layout. 

> Alternatively, I'm going to experiment with an approach where a volume group
> is done on two PV: one HDD and one SSD. The idea is to create the LV on
> the HDD and then move some extents (for example 0,1,64,65,128,129,...) to
> the SSD, so that metadata happens to be on the SSD.
> From what I found about the on-disk format, this is highly approximate
> and surely inelegant, so I wonder if a simpler solution exists.
> 
> Thanks.
> 
> -- 
>   Roberto Ragusa    mail at robertoragusa.it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
