From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 15:16:31 +0800
Message-ID: <4C91C44F.40700@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
>> When the dest and the src do overlap and the memory area is large, memmove
>> of
>> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
>> file
>> deletion performance. This patch improved the performance of memmove on
>> x86_64
>> by using __memcpy_bwd() instead of byte copy when doing large memory area
>> copy
>> (len>  64).
>
>
> I still don't understand why you don't simply use a backwards
> string copy (with std) ? That should be much simpler and
> hopefully be as optimized for kernel copies on recent CPUs.

But according to the comment of memcpy, some CPUs don't support "REP" instruction,
so I think we must implement a backwards string copy by other method for those CPUs,
But that implement is complex, so I write it as a function -- __memcpy_bwd().

Thanks!
Miao
