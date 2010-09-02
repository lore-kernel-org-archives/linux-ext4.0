From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and functions
Date: Thu, 02 Sep 2010 18:11:31 +0800
Message-ID: <4C7F7853.6000400@cn.fujitsu.com>
References: <4C7F3A2A.2000007@cn.fujitsu.com> <877hj4o76p.fsf@basil.nowhere.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020403060703070708030602"
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877hj4o76p.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------020403060703070708030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Thu, 02 Sep 2010 10:55:58 +0200, Andi Kleen wrote:
> Miao Xie<miaox@cn.fujitsu.com>  writes:
>
>> Changes from V1 to V2:
>> - change the version of GPL from version 2.1 to version 2
>>
>> the kernel's memcpy and memmove is very inefficient. But the glibc version is
>> quite fast, in some cases it is 10 times faster than the kernel version. So I
>
>
> Can you elaborate on which CPUs and with what workloads you measured that?

I did this test on x86_64 box with 4 cores, and the workload is quite low,
and I just do 500 bytes copy for 5,000,000 times.

the attached file is my test program.

> The kernel memcpy is optimized for copies smaller than a page size
> for example (kernel very rarely does anything on larger than 4k),
> the glibc isn't. etc. There are various other differences.
>
> memcpy and memmove are very different. AFAIK noone has tried
> to optimize memmove() before because traditionally it wasn't
> used for anything performance critical in the kernel. Has that
> that changed? memcpy on the other hand while not perfect
> is actually quite optimized for typical workloads.

Yes,the performance of memcpy on the most architecture is well,

But some of memmoves are implemented by byte copy, it is quite inefficient.
Unfortunately those memmove are used to modify the metadata of some filesystems,
such as: btrfs. That is memmove is importent for the performance of those filesystems.

So I improve the generic version of memcpy and memmove, and x86_64's memmove
which are implemented by byte copy.

> One big difference between the kernel and glibc is that kernel
> is often cache cold, so you e.g. the cost of a very large code footprint
> memcpy/memset is harder to amortize.
>
> Microbenchmarks often leave out that crucial variable.
>
> I have some systemtap scripts to measure size/alignment distributions of
> copies on a kernel, if you have a particular workload you're interested
> in those could be tried.

Good! Could you give me these script?

> Just copying the glibc bloat uncritical is very likely
> the wrong move at least.

Agree!

Thanks!
Miao

--------------020403060703070708030602
Content-Type: text/x-csrc;
 name="perf_memcopy.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf_memcopy.c"

#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/time.h>
#include <linux/sched.h>
#include <linux/err.h>
#include <linux/string.h>
#include <linux/slab.h>

void get_start_time(struct timeval *tv)
{
	do_gettimeofday(tv);
}

void account_time(struct timeval *stv, struct timeval *etv, int loops)
{
	do_gettimeofday(etv);

	if (loops) {
		while (etv->tv_usec < stv->tv_usec) {
			etv->tv_sec--;
			etv->tv_usec += 1000000;
		}

		etv->tv_usec -= stv->tv_usec;
		etv->tv_sec -= stv->tv_sec;

		while (etv->tv_usec > 1000000) {
			etv->tv_usec -= 1000000;
			etv->tv_sec++;
		}

		printk("\tTotal loops: %d\n", loops);
		printk("\tTotal time: %lds%ldus\n", etv->tv_sec, etv->tv_usec);
	} else
		printk("Didn't do any loop!\n");

}

char *str;

int init_module(void)
{
	struct timeval stv, etv;
	int loops, i;

	str = kmalloc(1000, GFP_KERNEL);
	if (!str)
		return 0;
	loops = i = 5000000;

	printk("memcpy:\n");
	get_start_time(&stv);
	while (i--)
		memcpy(str + 400, str, 500);
	account_time(&stv, &etv, loops);

	i = loops;
	printk("\nmemmove:\n");
	get_start_time(&stv);
	while (i--)
		memmove(str + 400, str, 500);
	account_time(&stv, &etv, loops);

	return 0;
}

void cleanup_module(void)
{
	kfree(str);
}

MODULE_LICENSE("GPL");

--------------020403060703070708030602--
