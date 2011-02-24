From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Thu, 24 Feb 2011 10:36:43 -0600
Message-ID: <4D66891B.5000206@redhat.com>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>	<4D6538C6.4090004@redhat.com> <AANLkTi=E_yGKHS8J3=hW2jxv+8wmTDJSPPysGihV84AR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1BXQgp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 11:36:45 -0500
In-Reply-To: <AANLkTi=E_yGKHS8J3=hW2jxv+8wmTDJSPPysGihV84AR@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/23/2011 06:33 PM, Yongqiang Yang wrote:
> On Thu, Feb 24, 2011 at 12:41 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 2/23/11 9:59 AM, Yongqiang Yang wrote:

...

>>> @@ -3830,7 +3845,8 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
>>>        *
>>>        * XXX this might miss a single-block extent at EXT_MAX_BLOCK
>>>        */
>>> -     if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
>>> +     end = ext4_ext_next_allocated_block(path);
>>
>> I think this will fall down if you have:
>>
>> [ HOLE ][ DELALLOC ][ HOLE ][ ALLOCATED ] won't it?
>>
>> i.e. your "end" will be the first block of "allocated" right?
> Yes, but it neglect nothing.  If we want to deal his model, we need to
> lookup dirty pages in specified range.
> 

I think it's clearly a bug to return a delalloc range when in fact it's
a hole...

> We use pagevec_lookup_tag() instead of find_get_page() and check
> BH_Delay of contiguous pages. Then, we can deal this model.

Yes, that's how I was going to go about it before you jumped right in,
thanks! :)

-Eric
