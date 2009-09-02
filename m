From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 2/4]ext4: Remove unneeded BUG_ON() in ext4_move_extents()
Date: Wed, 02 Sep 2009 15:48:49 +0900
Message-ID: <4A9E1551.6050804@rs.jp.nec.com>
References: <4A9DE3E5.8080104@rs.jp.nec.com> <6149e97b0909012238i6be6d8deg457a6f308608f1f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62221 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZIBGtL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 02:49:11 -0400
In-Reply-To: <6149e97b0909012238i6be6d8deg457a6f308608f1f8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,
Peng Tao wrote:
> 2009/9/2 Akira Fujita <a-fujita@rs.jp.nec.com>:
>> ext4: Remove unneeded BUG_ON() in ext4_move_extents()
>>
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>>
>> ext4_move_extents() checks with BUG_ON() whether
>> the exchanged blocks count accords with request blocks count.
>> But, if the target range (orig_start + len) includes sparse block(s),
>> 'moved_len' (exchanged blocks count) does not accord with
>> 'len' (request blocks count),
>> since sparse block is not counted in 'moved_len'.
>> Therefore we hit BUG_ON(), though it succeeded.
> I can confirm the bug in my test cases too.

I am looking into the issues you reported before:
http://marc.info/?l=linux-ext4&m=124975192830024&w=2
http://marc.info/?l=linux-ext4&m=124992522305319&w=2

When I send patches to the list, please review and test them.

Regards,
Akira Fujita

