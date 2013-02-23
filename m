From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sat, 23 Feb 2013 18:00:35 +0800
Message-ID: <51289343.90704@gmail.com>
References: <87obfcs1x6.fsf@openvz.org> <20130222180325.GB21264@thunk.org> <87txp3cqwt.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab3BWKAm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2013 05:00:42 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so845427pbc.5
        for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2013 02:00:41 -0800 (PST)
In-Reply-To: <87txp3cqwt.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/23/2013 05:37 PM, Dmitry Monakhov wrote:
> On Fri, 22 Feb 2013 13:03:25 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
>> On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
>>>
>>> 301'th xfstests are failed due to :
>>> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
>>> Author: Zheng Liu <wenqing.lz@taobao.com>
>>> Date:   Mon Feb 18 00:29:59 2013 -0500
>>>
>>>     ext4: lookup block mapping in extent status tree
>>>
>>> TESTCASE: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
>>
>> Thanks for the heads up.  I haven't updatied the xfstests I've been
>> using yet, since I want to make sure I'm comparing apples and oranges
>> during the merge window when I'm checking for regressions; I'll update
>> my xfstests in a week or two after the merge window settles down, and
>> then I'll rerun my baseline tests using the updated xfstests against
>> 3.8.0 and 3.9-rc2 or 3.9-rc3.
>>
>> (And furthermore, these new xfstests aren't yet in xfstests upstream
>> yet, right?  Any comments from the xfstests maintainer about whether
>> they are going to be willing to take your proposed new test cases?)
> I hope so. I think i've fixed things according to Dave's commit.
>> So when you say this is a regression, I take it that this test #301
>> doesn't fail on commit d100eef2440f^, but it does fail on d100eef2440f,
>> correct?
> Correct. d100ee is the first bad commit which trigger BUGON()
> But issue was introduced earlier  es_cache was not updated
> after extents was swapped between inodes.

Yes, you are right.  I forgot to update status tree after we do a
defragmentation.

> I'll prepare patch soon.

Ah, thanks.  So I will wait your patch.

> Actually I think that the regression in 269'th you have found recently
> caused by similar issue and commit which you foud by bisecting ( the one
> which allow migration between indirect<->extent based inodes)
> simply helps to spot real issue in es_caching code.

I will revise this patch.  IIRC, we forgot to update status tree after
an inode is migrated from extent-based to indirect-based.  Thanks for
pointing out.

> 
> BUT my main idea is that we need robust self-testing infrastructure
> similar one that we have at the time extents was introduced to ext4. 

Could you please share more detailed with me?  Extents had been
introduced for a long time ago.  I have missed too many things.

Thanks,
						- Zheng

