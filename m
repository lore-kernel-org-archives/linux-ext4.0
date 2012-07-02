From: Andrew Perepechko <anserper@ya.ru>
Subject: Re: dead/wrong code in ext3/4_releasepage()
Date: Mon, 02 Jul 2012 21:14:58 +0400
Message-ID: <4FF1D712.3060402@ya.ru>
References: <4FEDDD63.4000800@ya.ru> <20120702170959.GJ6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward5h.mail.yandex.net ([84.201.186.23]:48266 "EHLO
	forward5h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2GBRVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2012 13:21:14 -0400
In-Reply-To: <20120702170959.GJ6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan!
So you think the correct fix would be to remove the check completely
since every try_to_release_page() caller is obliged to perform the
page_has_private() check?
Thank you,
Andrew
On 07/02/2012 09:09 PM, Jan Kara wrote:
> On Fri 29-06-12 20:52:51, Andrew Perepechko wrote:
>> This does not lead to oom or any similar issue since calls to
>> try_to_release_page()
>> are accompanied by page_has_private() checks.
>>
>>
>    The check is a dead code because ->release_page() is called only if
> PagePrivate bit is set.
>
> 								Honza

