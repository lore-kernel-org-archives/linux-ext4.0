From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: save goal group and offset in struct ext4_allocation_context.ac_g_ex
Date: Fri, 1 Aug 2014 09:13:49 +0800
Message-ID: <53DAE9CD.5090308@cn.fujitsu.com>
References: <1406108861-2581-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <20140729135819.GA2256@thunk.org> <20140731153255.GE1566@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <adilger@dilger.ca>,
	<lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41300 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753421AbaHABOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:14:38 -0400
In-Reply-To: <20140731153255.GE1566@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On 07/31/2014 11:32 PM, Theodore Ts'o wrote:
> On Tue, Jul 29, 2014 at 09:58:19AM -0400, Theodore Ts'o wrote:
>> On Wed, Jul 23, 2014 at 05:47:41PM +0800, Xiaoguang Wang wrote:
>>> In ext4_mb_normalize_request(), if ac_g_ex.fe_logical is adjacent to the closest logical
>>> allocated block to the left or (ac_g_ex.fe_logical+len) adjacent to the closest logical
>>> allocated block to the right, we'll attach EXT4_MB_HINT_TRY_GOAL flag taking the physical
>>> block (ext4_allocation_request.lleft+1) or (ext4_allocation_request.pright-len) as a goal,
>>> and put this information in ext4_allocation_context.ac_f_ex.
>>>
>>> But look at the ext4_mb_find_by_goal(), indeed it use ac_g_ex to look up, so this is wrong,
>>> we should save goal group and offset in struct ext4_allocation_context.ac_g_ex.
>>>
>>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>>
>> Nice catch!
>>
>> Thanks, applied.
> 
> I've had to drop this patch, as it is causing xfstests failures for
> generic/074.

Before sending this patch, I didn't run the whole xfstests for ext4, sorry.
Next time, if I'll send some new patches, I'll run the xfstests for ext4.
> 
> I'm not sure why, and right now I don't have time to investigate.  If
> someone who has time and experience wading into fs/ext4/mballoc.c, it
> would be great if someone could take a closer look.

I'll investigate it and have full tests, thanks!

Regards,
Xiaoguang Wang
> 
>       	       	  	  	       - Ted
> .
> 

