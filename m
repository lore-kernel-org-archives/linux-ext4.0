From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
 in 	failure
Date: Mon, 14 Sep 2009 15:16:47 +0900
Message-ID: <4AADDFCF.9010602@rs.jp.nec.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com> <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com> <4AA0E419.7010707@rs.jp.nec.com> <4AA143B2.6060401@gmail.com> <4AA5D984.6030607@rs.jp.nec.com> <4AA60F36.9040605@gmail.com> <4AA9DAF0.2020402@rs.jp.nec.com> <4AAA816F.6060809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64139 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZINGRY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 02:17:24 -0400
In-Reply-To: <4AAA816F.6060809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,

Peng Tao wrote:
>> I tried to reproduce your problem with the following steps,
>> but I couldn't. Please check my procedure.
>>
>> 1. Test environment
>> linux2.6.31-rc2 + two patches as follows:
>> http://marc.info/?l=linux-ext4&m=125186152727422&w=3
>> http://marc.info/?l=linux-ext4&m=125205817410548&w=3
>>
>> 2. Create ext4 filesystem and mount it
>> mke2fs -t ext4 -b 4096 /dev/XXX
>> mount -t ext4 -O rw,noatime,relatime,commit=360 /dev/XXX /mnt/XXX
>>
>> 3. Create orig and donor files
>> dd if=/dev/urandom of=/mnt/XXX/first.img bs=10M count=1
>> dd if=/dev/zero of=/mnt/XXX/first.img bs=10M count=0 seek=50
>> dd if=/dev/urandom of=/mnt/XXX/last.img bs=10M count=1 seek=49
>>
>> 4. Call EXT4_MOVE_MOVE_EXT ioctl to files with the following arguments
>> (orig_file = /mnt/XXX/first.img, donor_file = /mnt/XXX/last.img)
>> move_data.orig_start = 0;
>> move_data.donor_start = 0;
>> move_data.len = 12152;
>> ioctl(orig_fd, EXT4_IOC_MOVE_EXT, &move_data)
>>
>> However, EXT4_IOC_MOVE_EXT returned ENODATA (this is a fine result by my patch)
>> and it didn't occur the kernel panic which you got.
>> If I chose a wrong step, please correct me.
> Sorry, I didn't notice that I was at commit 7638d5322bd89d49e013a03fe2afaeb6d214fabd
> of linus tree that includes a few patches after 2.6.31-rc2.
>> I appreciate if you could test following environment.
>> - 2.6.31-rc8 + ext4 patch queue
>>  (commit:bdacccd94d08a3f89e7fca676b28aa262c6d75fa) + attached patch
> I can't reproduce the panic in the above environment. I believe the problem
> is fixed. Thanks for your work!

Ok, I will re-base the patch and then send it to the list.
Thanks for your work, too.

Regards,
Akira Fujita.
