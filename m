From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 64k Page size + ext3 errors
Date: Mon, 28 Jul 2008 01:04:39 -0700
Message-ID: <e9c3a7c20807280104r33da4b85l8e1bff7ba91e0335@mail.gmail.com>
References: <576234.24141.qm@web81307.mail.mud.yahoo.com>
	 <65201.98.240.208.105.1217209925.squirrel@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "tirumalareddy marri" <tirumalareddymarri@yahoo.com>,
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org
To: sandeen@sandeen.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:53360 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYG1IEk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 04:04:40 -0400
Received: by wr-out-0506.google.com with SMTP id 69so3704858wri.5
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 01:04:39 -0700 (PDT)
In-Reply-To: <65201.98.240.208.105.1217209925.squirrel@sandeen.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 6:52 PM,  <sandeen@sandeen.net> wrote:
>> I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-fs
>> errors when I use 64K page size. When I use 4K page size I don't see any
>> issue. As many of you know, we will get better performance when we store
>> bigger files like videos.
>
> Do you think it is specific to the filesystem on raid-5?  Have you tested
> w/o md?  I'd be a little surprised if the problem is at the raid layer (so
> cc'ing the ext3/4 list), but maybe you tested that already.
>
> Which arch is it, and which kernel?  How big is the filesystem?  With full
> geometry information it might be easier for someone to reproduce & debug.
>

Marri, can you post your XOR driver the problem may be there.

Thanks,
Dan
