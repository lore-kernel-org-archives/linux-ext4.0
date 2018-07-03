From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: [PATCH 1/2] fs: ext4: use BUG_ON if writepage call comes from
 direct reclaim
Date: Tue, 3 Jul 2018 16:10:51 -0700
Message-ID: <f15b7474-66bd-515b-9c0e-16909bb2255d@linux.alibaba.com>
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
 <20180703103948.GB27426@thunk.org>
 <6c305241-d502-b8ea-a187-54c33e4ca692@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>, mgorman@techsingularity.net,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6c305241-d502-b8ea-a187-54c33e4ca692@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 7/3/18 10:05 AM, Yang Shi wrote:
>
>
> On 7/3/18 3:39 AM, Theodore Y. Ts'o wrote:
>> On Tue, Jul 03, 2018 at 12:11:18PM +0800, Yang Shi wrote:
>>> direct reclaim doesn't write out filesystem page, only kswapd could do
>>> it. So, if the call comes from direct reclaim, it is definitely a bug.
>>>
>>> And, Mel Gormane also mentioned "Ultimately, this will be a BUG_ON." In
>>> commit 94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct
>>> reclaim tries to writeback pages").
>>>
>>> Although it is for xfs, ext4 has the similar behavior, so elevate
>>> WARN_ON to BUG_ON.
>>>
>>> And, correct the comment accordingly.
>>>
>>> Cc: Mel Gorman <mgorman@techsingularity.net>
>>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>> What's the upside of crashing the kernel if the file sytsem can 
>> handle it?

BTW, the comment does sound misleading. Direct reclaim is not a 
legitimate context to call writepage. I'd like to correct at least.

Thanks,
Yang

>
> I'm not sure if it is a good choice to let filesystem handle such 
> vital VM regression. IMHO, writing out filesystem page from direct 
> reclaim context is a vital VM bug. It means something is definitely 
> wrong in VM. It should never happen.
>
> It sounds ok to have filesystem throw out warning and handle it, but 
> I'm not sure if someone will just ignore the warning, but it should 
> *never* be ignored.
>
> Yang
>
>>
>>                                                 - Ted
>
