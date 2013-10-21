From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Weird jbd2 I/O load
Date: Mon, 21 Oct 2013 20:42:50 +0300
Message-ID: <5265679A.4050600@redhost.ro>
References: <525DB679.4070008@redhost.ro> <20131021135338.GA3392@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gts6.roserve.net ([128.140.230.209]:46584 "EHLO
	gts6.roserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3JURmx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 13:42:53 -0400
In-Reply-To: <20131021135338.GA3392@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Meantime I've created another md device (just 5GB) and I've redone the 
tests. I believe
this is easier and less risky than remounting an used md device.

root [/home2]# mount -l | grep md3
/dev/md3 on /home2 type ext4 (rw,barrier=0)

root [/home2]# dd bs=2M count=64 if=/dev/zero of=test6 conv=fdatasync
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 12.3287 s, 10.9 MB/s

So the speed issue is still with us I believe.

Is there some way to check the barrier is really set to 0?

Thanks a lot!

On 10/21/2013 4:53 PM, Zheng Liu wrote:
> Hi Andrei,
>
> Could you please disable barrier for ext4 and try your 'dd' test again?
>    $ sudo mount -t ext4 -o remount,barrier=0 ${DEV} ${MNT}
>
> *WARNING: you could lost your data with barrier=0 when you get a power
> failure or cold reset.*
>
> We have met a similar problem that is because some SSDs couldn't handle
> barrier command properly.
>
> Regards,
>                                                  - Zheng

