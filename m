From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and   
   functions
Date: Wed, 08 Sep 2010 21:32:42 +0800
Message-ID: <4C87907A.2040500@cn.fujitsu.com>
References: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>	<4C878823.60709@cn.fujitsu.com> <20100908150519.2f9fe283@basil.nowhere.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100908150519.2f9fe283@basil.nowhere.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 8 Sep 2010 15:05:19 +0200, Andi Kleen wrote:
> On Wed, 08 Sep 2010 20:57:07 +0800
> Miao Xie<miaox@cn.fujitsu.com>  wrote:
>
>> On Wed, 8 Sep 2010 14:19:25 +0200 (cest), Andi Kleen wrote:
>>>
>>>> According to the data, the length of the most copies is>=128.
>>>
>>> Thanks for the data. Large is easier to optimize than small, that's
>>> good.
>>>
>>> Could you also measure how many memsets need the backwards copy?
                                     ^^^^^^^ :-)
>>> (should be easy to add)
>>
>> I think memset doesn't need the backwards copy.
>
> I meant for memmove of course. Obviously memset doesn't need a backwards
> copy. That was just the only thing the script didn't measure because
> the original version didn't have memmove support.

memmove
total 5224252
[snip]

forward copy
value |-------------------------------------------------- count
     0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  980253


backward copy
value |-------------------------------------------------- count
     0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  4243999

the backward copy is much more than the forward copy.

Thanks
Miao


