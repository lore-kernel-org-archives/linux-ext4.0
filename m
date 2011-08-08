From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 08 Aug 2011 13:27:12 +0900
Message-ID: <4E3F65A0.9090109@jp.fujitsu.com>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com> <20110801084526.GB6522@quack.suse.cz> <4E3675D6.3010201@jp.fujitsu.com> <20110801095731.GI6522@quack.suse.cz> <4E37BFEA.7020601@jp.fujitsu.com> <4E38B57B.4050304@jp.fujitsu.com> <20110803095754.GA5047@quack.suse.cz> <20110803222548.7c1ee229.toshi.okajima@jp.fujitsu.com> <20110803162525.GB10815@quack.suse.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44728 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1HHE0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Aug 2011 00:26:25 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 599B23EE0BC
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 13:26:23 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3DCAA45DE85
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 13:26:23 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1AF6345DE7E
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 13:26:23 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 081A81DB803F
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 13:26:23 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B6DED1DB803E
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 13:26:22 +0900 (JST)
In-Reply-To: <20110803162525.GB10815@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I'm sorry for my late response. I took vacations till yesterday.

(2011/08/04 1:25), Jan Kara wrote:
>    Hello,
>
> On Wed 03-08-11 22:25:48, Toshiyuki Okajima wrote:
>> On Wed, 3 Aug 2011 11:57:54 +0200
>> Jan Kara<jack@suse.cz>  wrote:
>>> On Wed 03-08-11 11:42:03, Toshiyuki Okajima wrote:
>>>>> (2011/08/01 18:57), Jan Kara wrote:
>>>>>> On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
>>>>>>> (2011/08/01 17:45), Jan Kara wrote:
>>>>>>>> On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
>>>>>>>>> If there are some inodes in orphan list while a filesystem is=
 being
>>>>>>>>> read-only mounted, we should recommend that pepole umount and=
 then
>>>>>>>>> mount it when they try to remount with read-write. But the cu=
rrent
>>>>>>>>> message/comment recommends that they umount and then remount =
it.
>>>> <SNIP>
>>>>>>>> the most... BTW, I guess you didn't really see this message in=
 practice, did
>>>>>>>> you?
>>>>>>> No.
>>>>>>> I have seen this message in practice while quotacheck command w=
as repeatedly
>>>>>>> executed per an hour.
>>>>>> Interesting. Are you able to reproduce this? Quotacheck does rem=
ount
>>>>>> read-only + remount read-write but you cannot really remount the=
 filesystem
>>>>>> read-only when it has orphan inodes and so you should not see th=
ose when
>>>>>> you remount read-write again. Possibly there's race between remo=
unting and
>>>>>> unlinking...
>>>>> Yes. I can reproduce it. However, it is not frequently reproduced
>>>>> by using the original procedure (qutacheck per an hour). So, I ma=
de a
>>>>> reproducer.
>>>> To tell the truth, I think the race creates the message:
>>>> ------------------------------------------------------------------=
-----
>>>>   EXT3-fs:<dev>: couldn't remount RDWR because of
>>>>   =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode li=
st.  Please umount/remount instead.
>>>> ------------------------------------------------------------------=
-----
>>>> which hides a serious problem.
>>>    I've inquired about this at linux-fsdevel (I think you were in C=
C unless
>>> I forgot). It's a race in VFS remount code as you properly analyzed=
 below.
>>> People are working on fixing it but it's not trivial. Filesystem is=
 really
>>> a wrong place to fix such problem. If there is a trivial fix for ex=
t3 to
>>> workaround the issue, I can take it but I'm not willing to push any=
thing
>>> complex - effort should better be spent working on a generic fix.
>> I also think read-only remount race in VFS layer should be fixed.
>> However, I think this race depends on ext3/ext4 filesystem
>> implementation. (Orphan inode list)
>> So, we should modify ext3/ext4(jbd/jbd2) to fix it.

>    Umm, I don't understand here. If VFS makes sure that there are no

After I saw the following messages, I thought we must fix EXT3-fs error
at first. So, I created the fix patch.

(1) kernel: EXT3-fs: <dev>: couldn't remount RDWR because of
  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode list.  =
Please umount/remount instead.
(2) kernel: EXT3-fs error (device <dev>) in start_transaction: Readonly=
 filesystem

I wasn't aware that by fixing the race between "ro-remount" and "unlink=
",
that EXT3-fs error can be also fixed then.

> files open for writing, no unfinished operations changing the filesys=
tem (e.g.
> unlink), and no open-but-unlinked files, what remains for ext3 to che=
ck?
OK.
Now, I also think we need not modify ext3 to fix these problems.
If we can prevent to add an inode into the orphan list (to start unlink=
ing)
while ro-remounting, we can also prevent (1) and (2).

However, new mechanism to confirm whether "no open-but-unlinked" files
exist while ro-remounting is required, isn't it?
 =20
Thanks,
Toshiyuki Okajima

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
