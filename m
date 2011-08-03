From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Wed, 03 Aug 2011 11:42:03 +0900
Message-ID: <4E38B57B.4050304@jp.fujitsu.com>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com> <20110801084526.GB6522@quack.suse.cz> <4E3675D6.3010201@jp.fujitsu.com> <20110801095731.GI6522@quack.suse.cz> <4E37BFEA.7020601@jp.fujitsu.com>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46093 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1HCClW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 22:41:22 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 4BDCB3EE0BB
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 11:41:20 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 347AA45DE9E
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 11:41:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 089F645DEA6
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 11:41:20 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EE4F51DB803C
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 11:41:19 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id AC2041DB803B
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 11:41:19 +0900 (JST)
In-Reply-To: <4E37BFEA.7020601@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2011/08/02 18:14), Toshiyuki Okajima wrote:
> Hi.
>
> (2011/08/01 18:57), Jan Kara wrote:
>> On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
>>> (2011/08/01 17:45), Jan Kara wrote:
>>>> On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
>>>>> If there are some inodes in orphan list while a filesystem is bei=
ng
>>>>> read-only mounted, we should recommend that pepole umount and the=
n
>>>>> mount it when they try to remount with read-write. But the curren=
t
>>>>> message/comment recommends that they umount and then remount it.
<SNIP>
>>>> the most... BTW, I guess you didn't really see this message in pra=
ctice, did
>>>> you?
>>> No.
>>> I have seen this message in practice while quotacheck command was r=
epeatedly
>>> executed per an hour.
>> Interesting. Are you able to reproduce this? Quotacheck does remount
>> read-only + remount read-write but you cannot really remount the fil=
esystem
>> read-only when it has orphan inodes and so you should not see those =
when
>> you remount read-write again. Possibly there's race between remounti=
ng and
>> unlinking...
> Yes. I can reproduce it. However, it is not frequently reproduced
> by using the original procedure (qutacheck per an hour). So, I made a
> reproducer.
To tell the truth, I think the race creates the message:
-----------------------------------------------------------------------
  EXT3-fs: <dev>: couldn't remount RDWR because of
  =E3=80=80=E3=80=80=E3=80=80 =E3=80=80unprocessed orphan inode list.  =
Please umount/remount instead.
-----------------------------------------------------------------------
which hides a serious problem.

By using my reproducer, I found that it can show another message that
is not the above mentioned message:
-----------------------------------------------------------------------
EXT3-fs error (device <dev>) in start_transaction: Readonly filesystem=09
-----------------------------------------------------------------------
After I examined the code path which message could display, I found
it can display if the following steps are satisfied:

[[CASE 1]]
( 1)  [process A] do_unlinkat
( 2)  [process B] do_remount_sb(, RDONLY, )
( 3)  [process A]  vfs_unlink
( 4)  [process A]   ext3_unlink
( 5)  [process A]    ext3_journal_start
( 6)  [process B]  fs_may_remount_ro   (=3D> return 0)
( 7)  [process A]    inode->i_nlink-- (i_nlink=3D0)
( 8)  [process A]    ext3_orphan_add
( 9)  [process A]    ext3_journal_stop
(10)  [process A]  dput
(11)  [process A]   iput
(12)  [process A]    ext3_evict_inode
(13)  [process B]  ext3_remount
(14)  [process A]     start_transaction
(15)  [process B]   sb->s_flags |=3D MS_RDONLY
(16)  [process B]   ext3_mark_recovery_complete
(17)  [process A]      start_this_handle (new transaction is created)
(18)  [process A]     ext3_truncate
(19)  [process A]      start_transaction (failed =3D> this message is d=
isplayed)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^
(20)  [process A]     ext3_orphan_del
(21)  [process A]     ext3_journal_stop

* "Process A" deletes a file successfully(21). However the file data is=
 left
    because (18) fails. **Furthermore, new transaction can be created a=
fter
    ext3_mark_recovery_complete finishes.**

[[CASE2]]
( 1)  [process A] do_unlinkat
( 2)  [process B] do_remount_sb(, RDONLY, )
( 3)  [process A]  vfs_unlink
( 4)  [process A]   ext3_unlink
( 5)  [process A]    ext3_journal_start
( 6)  [process B]  fs_may_remount_ro   (=3D> return 0)
( 7)  [process A]    inode->i_nlink-- (i_nlink=3D0)
( 8)  [process A]    ext3_orphan_add
( 9)  [process A]    ext3_journal_stop
(10)  [process A]  dput
(11)  [process A]   iput
(12)  [process A]    ext3_evict_inode
(13)  [process B]  ext3_remount
(14)  [process A]     start_transaction
(15)  [process B]   sb->s_flags |=3D MS_RDONLY
(17)  [process A]      start_this_handle (new transaction is created)
(18)  [process A]     ext3_truncate
(19)  [process A]      start_transaction (failed =3D> this message is d=
isplayed)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^
(20)  [process A]     ext3_orphan_del
(21)  [process A]     ext3_journal_stop
(22)  [process B]   ext3_mark_recovery_complete

* "Process A" deletes a file successfully(21). However the file data is=
 left
    because (18) fails. This transaction can finish before
    ext3_mark_recovery_complete finishes.

I will try to fix this problem not to do with fs-error.
Please comment about the fix if I have created one.

Thanks,
Toshiyuki Okajima

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
