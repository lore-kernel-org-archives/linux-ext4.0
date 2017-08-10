From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Release of e2fsprogs 1.43.5
Date: Thu, 10 Aug 2017 11:05:45 -0700
Message-ID: <a72d34d5-9c9f-4d4c-2669-2397a98a4313@redhat.com>
References: <20170805163409.y5ifkldbmwzy4hge@thunk.org>
 <552dd796-7ba5-6a10-b9fd-0d1a2aa07041@redhat.com>
 <20170810173044.GA16896@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753010AbdHJSFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Aug 2017 14:05:46 -0400
In-Reply-To: <20170810173044.GA16896@localhost.localdomain>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/10/17 10:30 AM, Eric Whitney wrote:
> * Eric Sandeen <esandeen@redhat.com>:

...

>> 336 tests succeeded	3 tests failed
>> Tests failed: f_del_dup_quota f_quota f_quota_extent_opt 
>>
>> Haven't dug into this yet (failures are on ephemeral build root
>> on a build host), but has anyone else seen problems?
>>
> 
> Yes - I can reproduce these failures on Debian Jessie on 32 bit x86, as can
> Ted.
> 
> Reverting "libext2fs: fix compile errors/warnings" (a850bc56e0aa) resolves
> the problem for me.  In particular, undoing the format string changes in
> scan_dquots_callback() fixes the failures.  I think we need to use %lld as
> dqb_curspace and dqb_curinodes are __le64, as addressed in "e2fsck: fix type
> mismatches in quota warning message" (f09669fc6889).

Cool, thanks Eric.

-Eric
