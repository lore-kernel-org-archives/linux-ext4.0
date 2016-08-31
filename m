From: Chao Yu <chao@kernel.org>
Subject: Re: mbcache: fix to detect failure of register_shrinker
Date: Thu, 1 Sep 2016 00:19:01 +0800
Message-ID: <0daeb49f-54b3-0de4-a934-3bf74977df56@kernel.org>
References: <1463411798-2597-1-git-send-email-chao@kernel.org>
 <20160705201625.GA18568@thunk.org>
 <c0b249e8-8bc6-cfdb-8ee5-3d0b4618f84e@kernel.org>
 <20160831154831.y4234emrgvh5bwka@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935148AbcHaQTJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 31 Aug 2016 12:19:09 -0400
In-Reply-To: <20160831154831.y4234emrgvh5bwka@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2016/8/31 23:48, Theodore Ts'o wrote:
> On Wed, Aug 31, 2016 at 11:31:17PM +0800, Chao Yu wrote:
>> On 2016/7/6 4:16, Theodore Ts'o wrote:
>>> On Mon, May 16, 2016 at 11:16:38PM +0800, Chao Yu wrote:
>>>> From: Chao Yu <yuchao0@huawei.com>
>>>>
>>>> register_shrinker in mb_cache_create may fail due to no memory. This
>>>> patch fixes to do the check of return value of register_shrinker and
>>>> handle the error case, otherwise mb_cache_create may return with no
>>>> error, but losing the inner shrinker.
>>>>
>>>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>
>>> Applied, thanks.  (Apologies for the delay; this patch slipped through
>>> the cracks.)
>>
>> Ping, didn't see it in mainline, is this patch still under testing now?
> 
> I'm sorry, I'm not sure how it got dropped, but it's not in mainline
> and I'm not sure how it got dropped from the ext4 tree.
> 
> It's now queued up in the dev tree.
> 
> Thanks for checking back,

Thanks for merging! ;)

> 
> 						- Ted
> 
