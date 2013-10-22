From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Weird jbd2 I/O load
Date: Tue, 22 Oct 2013 10:22:22 +0300
Message-ID: <526627AE.9090501@redhost.ro>
References: <525DB679.4070008@redhost.ro> <20131021135338.GA3392@gmail.com> <5265679A.4050600@redhost.ro> <20131022025729.GA6247@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gts6.roserve.net ([128.140.230.209]:55570 "EHLO
	gts6.roserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3JVHWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Oct 2013 03:22:47 -0400
Received: from 5-13-211-235.residential.rdsnet.ro ([5.13.211.235]:44284 helo=[127.0.0.1])
	by gts6.roserve.net with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <andrei.banu@redhost.ro>)
	id 1VYWId-0000Fo-LF
	for linux-ext4@vger.kernel.org; Tue, 22 Oct 2013 10:22:43 +0300
In-Reply-To: <20131022025729.GA6247@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Thank you for your attempt to help me! By the way...I have checked 
/proc/mounts and it was barrier=0 so...I guess that is that.

Unfortunately this leaves me with only one thing to test and that is to 
swap the physical SSDs with each other and see if the apparent problems 
move from sdb to sda or stay on sdb. If they move I guess it's the SSD 
on sdb. But if the problems stay I guess the problem lies elsewhere. I 
am just not sure it's safe to swap the 2 devices of an mdraid array.

Thanks again and kind regards!

On 10/22/2013 5:57 AM, Zheng Liu wrote:
> On Mon, Oct 21, 2013 at 08:42:50PM +0300, Andrei Banu wrote:
>> Hi,
>>
>> Meantime I've created another md device (just 5GB) and I've redone
>> the tests. I believe
>> this is easier and less risky than remounting an used md device.
>>
>> root [/home2]# mount -l | grep md3
>> /dev/md3 on /home2 type ext4 (rw,barrier=0)
>>
>> root [/home2]# dd bs=2M count=64 if=/dev/zero of=test6 conv=fdatasync
>> 64+0 records in
>> 64+0 records out
>> 134217728 bytes (134 MB) copied, 12.3287 s, 10.9 MB/s
>>
>> So the speed issue is still with us I believe.
> Thanks for doing this.  It seems that the problem we met are different.
>
>> Is there some way to check the barrier is really set to 0?
> You have seen that from the output of 'mount' command barrier is 0.  You
> can 'cat /proc/mounts' to double-check it.  But it should be the same.
>
> Regards,
>                                                  - Zheng

