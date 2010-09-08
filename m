From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and   
   functions
Date: Wed, 08 Sep 2010 20:57:07 +0800
Message-ID: <4C878823.60709@cn.fujitsu.com>
References: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 8 Sep 2010 14:19:25 +0200 (cest), Andi Kleen wrote:
>
>> According to the data, the length of the most copies is>=128.
>
> Thanks for the data. Large is easier to optimize than small, that's good.
>
> Could you also measure how many memsets need the backwards copy?
> (should be easy to add)

I think memset doesn't need the backwards copy.
The reason why memmove needs the backward copy is because the forward copy may
cover the data which will be used later if the dest string intersect with the
src string. But memset needn't worry about this problem.

Thanks!
Miao  

>
> If the number is small that needs backwards then the easiest fix
> would be to simply call the normal memcpy in the forward case.
>
> That is for backward could also use a string instruction copy
> of course, just have to set the direction flag.
>
> That would be a very small code change.
>
> -Andi
>
>
>
>
