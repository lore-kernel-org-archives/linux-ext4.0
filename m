From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Weird jbd2 I/O load
Date: Tue, 22 Oct 2013 10:57:29 +0800
Message-ID: <20131022025729.GA6247@gmail.com>
References: <525DB679.4070008@redhost.ro>
 <20131021135338.GA3392@gmail.com>
 <5265679A.4050600@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58635 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3JVCzW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 22:55:22 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb12so7814137pbc.8
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 19:55:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5265679A.4050600@redhost.ro>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 21, 2013 at 08:42:50PM +0300, Andrei Banu wrote:
> Hi,
> 
> Meantime I've created another md device (just 5GB) and I've redone
> the tests. I believe
> this is easier and less risky than remounting an used md device.
> 
> root [/home2]# mount -l | grep md3
> /dev/md3 on /home2 type ext4 (rw,barrier=0)
> 
> root [/home2]# dd bs=2M count=64 if=/dev/zero of=test6 conv=fdatasync
> 64+0 records in
> 64+0 records out
> 134217728 bytes (134 MB) copied, 12.3287 s, 10.9 MB/s
> 
> So the speed issue is still with us I believe.

Thanks for doing this.  It seems that the problem we met are different.

> 
> Is there some way to check the barrier is really set to 0?

You have seen that from the output of 'mount' command barrier is 0.  You
can 'cat /proc/mounts' to double-check it.  But it should be the same.

Regards,
                                                - Zheng

> 
> Thanks a lot!
> 
> On 10/21/2013 4:53 PM, Zheng Liu wrote:
> >Hi Andrei,
> >
> >Could you please disable barrier for ext4 and try your 'dd' test again?
> >   $ sudo mount -t ext4 -o remount,barrier=0 ${DEV} ${MNT}
> >
> >*WARNING: you could lost your data with barrier=0 when you get a power
> >failure or cold reset.*
> >
> >We have met a similar problem that is because some SSDs couldn't handle
> >barrier command properly.
> >
> >Regards,
> >                                                 - Zheng
> 
