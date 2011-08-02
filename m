From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Tue, 02 Aug 2011 18:14:18 +0900
Message-ID: <4E37BFEA.7020601@jp.fujitsu.com>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com> <20110801084526.GB6522@quack.suse.cz> <4E3675D6.3010201@jp.fujitsu.com> <20110801095731.GI6522@quack.suse.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49639 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBJNk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 05:13:40 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3EABA3EE0AE
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:13:38 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2554A45DE51
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:13:38 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 03DB745DE4D
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:13:38 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E83871DB803F
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:13:37 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A54F41DB8037
	for <linux-ext4@vger.kernel.org>; Tue,  2 Aug 2011 18:13:37 +0900 (JST)
In-Reply-To: <20110801095731.GI6522@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2011/08/01 18:57), Jan Kara wrote:
> On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
>> (2011/08/01 17:45), Jan Kara wrote:
>>> On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
>>>> If there are some inodes in orphan list while a filesystem is being
>>>> read-only mounted, we should recommend that pepole umount and then
>>>> mount it when they try to remount with read-write. But the current
>>>> message/comment recommends that they umount and then remount it.
>>>>
>>>> ext3_remount:
>>>> 	/*
>>>> 	 * If we have an unprocessed orphan list hanging
>>>> 	 * around from a previously readonly bdev mount,
>>>> 	 * require a full umount/remount for now.
>>>>                            ^^^^^^^^^^^^^^
>>>> 	 */
>>>> 	if (es->s_last_orphan) {
>>>> 		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
>>>> 			"remount RDWR because of unprocessed "
>>>> 			"orphan inode list.  Please "
>>>> 			"umount/remount instead.\n",
>>>>                           ^^^^^^^^^^^^^^
>>>> 			sb->s_id);
>>
>>>    OK, so how about using "umount&   mount"? The '/' is what would confuse me
>> OK. I modify it like your comment.
>>
>>   umount/mount =>  umount&  mount
>    Thanks.
>

>>> the most... BTW, I guess you didn't really see this message in practice, did
>>> you?
>> No.
>> I have seen this message in practice while quotacheck command was repeatedly
>> executed per an hour.
>    Interesting. Are you able to reproduce this? Quotacheck does remount
> read-only + remount read-write but you cannot really remount the filesystem
> read-only when it has orphan inodes and so you should not see those when
> you remount read-write again. Possibly there's race between remounting and
> unlinking...
Yes. I can reproduce it. However, it is not frequently reproduced
by using the original procedure (qutacheck per an hour). So, I made a
reproducer.

It is:
[go.sh]
#!/bin/sh

dd if=/dev/zero of=./img bs=1k count=1 seek=100k > /dev/null 2>&1
/sbin/mkfs.ext3 -Fq ./img
/sbin/tune2fs -c 0 ./img
mkdir -p mnt
LOOP=10000
for ((i=0; i<LOOP; i++));
do
         mount -o loop ./img ./mnt
         sh ./writer.sh ./mnt &
         PID=$!
	j=0
         while [ 1 ];
         do
                 sleep 1
# remount
                 if ((j%2 == 0));
                 then
                         mount -o loop,remount,ro ./mnt
                 else
                         mount -o loop,remount,rw ./mnt
                 fi
                 tail -n 1 /var/log/messages| grep "remount RDWR"
                 if [ $? -eq 0 ];
                 then
                         break
                 fi
                 j=$((j+1))
         done
         kill -9 $PID
         umount ./mnt
         /sbin/e2fsck -pf ./img
done
exit

[writer.sh]
#!/bin/sh

i=0
path=$1
num=0
stride=64
while [ 1 ];
do
         for ((j=0;j<stride;j++));
         do
                 num=$((i*stride + j))
                 dd if=/dev/zero of=${path}/file${num} bs=8k count=1 > /dev/null 2>&1 &
         done
         for ((j=0;j<stride;j++));
         do
                 num=$((i*stride + j))
                 rm -f ${path}/file${num} &
         done
         wait
         i=$((i+1))
done

# vi go.sh
# vi writer.sh
# sh go.sh
(It might be reproduced after a while...)

Thanks,
Toshiyuki Okajima

