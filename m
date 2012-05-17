From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Wed, 16 May 2012 22:14:53 -0500
Message-ID: <4FB46D2D.1050107@redhat.com>
References: <1337158192-4591-1-git-send-email-tm@tao.ma> <4FB3AF00.9060704@redhat.com> <4FB3BFC9.20901@tao.ma> <4FB3CC8C.4030502@redhat.com> <4FB45FBE.10004@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760941Ab2EQDO5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 23:14:57 -0400
In-Reply-To: <4FB45FBE.10004@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/12 9:17 PM, Tao Ma wrote:
> On 05/16/2012 11:49 PM, Eric Sandeen wrote:
>> On 5/16/12 9:55 AM, Tao Ma wrote:
>>> On 05/16/2012 09:43 PM, Eric Sandeen wrote:
>>>> On 5/16/12 3:49 AM, Tao Ma wrote:
>>>>> From: Tao Ma <boyu.mt@taobao.com>
>>>>>
>>>>> Now when we set the group inode free count, we don't have a proper
>>>>> group lock so that multiple threads may decrease the inode free
>>>>> count at the same time. And e2fsck will complain something like:
>>>>
>>>> This is only in the ! EXT4_FEATURE_RO_COMPAT_GDT_CSUM case I guess?
>>>> That would be worth mentioning in the summary & changelog.
>>> sure, I will add it in v2.
>>>>
>>>> I guess you were testing without that for some reason?
>>> See my comments below. I found it when running xfstests 269.
>>
>> Still not sure how you got a filesystem w/o that feature though, unless
>> I am forgetting something obvious.  Isn't it on by default?
> oh, I see. Yes, we mkfs the system with the following configurations:
> mke2fs -O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr
> Maybe that's the reason why it has never be met by others before. ;)

Ok, good.  I figured it was in some barely-reachable corner
of the infinite test matrix ;)

-Eric

> Thanks
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

