From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [BUG][e2fsprogs] e2fsck: e2fsck reports ext3 message when checking
 ext4 filesystem
Date: Wed, 11 Feb 2009 10:35:06 +0800
Message-ID: <4992395A.8030301@cn.fujitsu.com>
References: <4951A916.706@cn.fujitsu.com> <ea11fea30812232040g1e939f87y6bfaf5e82df99dd1@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Linux-Ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZBKCho (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 21:37:44 -0500
In-Reply-To: <ea11fea30812232040g1e939f87y6bfaf5e82df99dd1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

on 2008-12-24 12:40 Manish Katiyar wrote:
> On Wed, Dec 24, 2008 at 8:44 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> Hi,
>>
>> I use "e2fsck" to repair the damaged ext4 device.
>>
>> The message was followings.
>>
>> ------
>> # ./e2fsck /dev/sdb3
>> e2fsck 1.41.3 (12-Oct-2008)
>> Superblock has an invalid ext3 journal (inode 8).
>> Clear<y>?
>> ---
>>
>> Why e2fsck tells me "ext3"?
> 
> Because it is hardcoded :-(
> 
>>From the file e2fsprogs/po/id.po :-
> 
> #. @-expanded: superblock has an invalid ext3 journal (inode %i).\n
> #: e2fsck/problem.c:187
> #, c-format
> msgid "@S has an @n ext3 @j (@i %i).\n"
> msgstr "@S memiliki sebuah @n ext3 @j (@i %i).\n"

someone submitted a patch to fix this bug. I tested it and the test was pass.
But I found the translation is not updated.

Thanks!
Miao

> 
> 
> Thanks -
> Manish
> 
>> It looks the message was wrong
>> or e2fsck doesn't recognize ext4 correctly.
>>
>> Thanks！
>> Miao Xie
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 


