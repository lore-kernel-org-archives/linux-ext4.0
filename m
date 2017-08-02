From: Sahitya Tummala <stummala@codeaurora.org>
Subject: Re: e2fsck on encrypted directories
Date: Wed, 2 Aug 2017 12:43:27 +0530
Message-ID: <045b2521-e3bb-7a5c-3bee-cc3d7308b254@codeaurora.org>
References: <23b72f10-bbe6-1e7d-89b6-7b8bebab8d13@codeaurora.org>
 <20170801143343.7kphdxfvw7qzth3z@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdHBHNb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Aug 2017 03:13:31 -0400
In-Reply-To: <20170801143343.7kphdxfvw7qzth3z@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 8/1/2017 8:03 PM, Theodore Ts'o wrote:
> On Fri, Jul 28, 2017 at 03:32:24PM +0530, Sahitya Tummala wrote:
>> Hi Ted,
>>
>> I got a question on usage of e2fsck with -D option on EXT4 FS, where
>> file based encryption is enabled. Is this option supposed to work on
>> encrypted directories?
>>
>> I have encountered a case where e2fsck gets stuck
>> in duplicate_search_and_fix() due to strncmp checks done in this function
>> on encrypted file names, which may contain NUL characters.
>>
>> Also, even without -D option passed, there can be a case of duplicate
>> entries (i.e.,
>> ctx->dirs_to_hash is not NULL). In this case too we may see the same issue
>> in duplicate_search_and_fix() if the directory is encrypted.
>> Is my understanding correct? Please share your comments.
> Thanks, your understanding is indeed correct.  Thanks for pointing
> this out.  The following patch should fix the problem; can you
> confirm, if you have a convenient test case?

Thanks for the patch. I could reproduce this issue only once so far. I 
have already
tried the proposed fix and it works fine.

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
