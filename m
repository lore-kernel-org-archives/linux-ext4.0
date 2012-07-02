From: Andrew Perepechko <anserper@ya.ru>
Subject: Re: dead/wrong code in ext3/4_releasepage()
Date: Mon, 02 Jul 2012 22:19:41 +0400
Message-ID: <4FF1E63D.8040707@ya.ru>
References: <4FEDDD63.4000800@ya.ru> <20120702170959.GJ6679@quack.suse.cz> <4FF1D712.3060402@ya.ru> <20120702173326.GL6679@quack.suse.cz> <20120702181720.GD5795@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward5.mail.yandex.net ([77.88.46.21]:45942 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2GBSaR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2012 14:30:17 -0400
In-Reply-To: <20120702181720.GD5795@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore!

Sent.

Thank you,
Andrew

On 07/02/2012 10:17 PM, Theodore Ts'o wrote:
> On Mon, Jul 02, 2012 at 07:33:26PM +0200, Jan Kara wrote:
>>    Hi,
>>
>> On Mon 02-07-12 21:14:58, Andrew Perepechko wrote:
>>> So you think the correct fix would be to remove the check completely
>>> since every try_to_release_page() caller is obliged to perform the
>>> page_has_private() check?
>>    Yes, I think that would be reasonable. XFS already relies on this so
>> it should be safe.
>
> Andrew, can you send me a patch?
>
> Thanks,
>
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

