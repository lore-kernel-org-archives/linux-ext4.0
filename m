From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_alloc_context occupies 150 GiB of memory and makes the system
 unusable
Date: Mon, 22 Nov 2010 09:24:58 -0600
Message-ID: <4CEA8B4A.3030608@redhat.com>
References: <201011221323.25342.bartoschek@or.uni-bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christoph Bartoschek <bartoschek@or.uni-bonn.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab0KVPZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 10:25:05 -0500
In-Reply-To: <201011221323.25342.bartoschek@or.uni-bonn.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/22/10 6:23 AM, Christoph Bartoschek wrote:
> Hi,
> 
> I have the problem that on one machine lots of memory is allocated for 
> ext4_alloc_context.
> 
> I would like to know for what purpose the memory is allocated and why it is 
> not given to processes that need memory.
> 
> The machine normally only uses a local ext4 for booting. The data it is 
> working on comes from NFS.
> 
> Now there are several normally CPU-bound jobs running but they only get 1-2% 
> of cputime because they are constantly swapping. They are swapping because of 
> the 192 GiB the machine has 150 GiB are allocated for ext4_alloc_context.  
> Here is the output of /dev/meminfo:

You probably want my patch,

commit 3e1e5f501632460184a98237d5460c521510535e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Oct 27 21:30:07 2010 -0400

    ext4: don't use ext4_allocation_contexts for tracing
    
    Many tracepoints were populating an ext4_allocation_context
    to pass in, but this requires a slab allocation even when
    tracepoints are off.  In fact, 4 of 5 of these allocations
    were only for tracing.  In addition, we were only using a
    small fraction of the 144 bytes of this structure for this
    purpose.
    
    We can do away with all these alloc/frees of the ac and
    simply pass in the bits we care about, instead.
    
    I tested this by turning on tracing and running through
    xfstests on x86_64.  I did not actually do anything with
    the trace output, however.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I don't know why the inactive slabs stay around, but there is no 
reason to be (ab)using this slab cache for this purpose, and the 
above commit just removes most users of the cache.

I -think- I have seen a case where even with this patch alloc_contexts
still hang around, and I can't explain it.  But you might start
with the above, as it should at least make things better.

...
> 
> We see that Slab uses most of the memory. And within slab nearly everything is 
> used for ext4_alloc_context. There is the output of slabtop:
> 
>  Active / Total Objects (% used)    : 364597 / 1070670469 (0.0%)
>  Active / Total Slabs (% used)      : 52397 / 39688960 (0.1%)
>  Active / Total Caches (% used)     : 107 / 193 (55.4%)
>  Active / Total Size (% used)       : 159579.25K / 150697605.41K (0.1%)
>  Minimum / Average / Maximum Object : 0.02K / 0.14K / 4096.00K
> 
>   OBJS     ACTIVE  USE OBJ SIZE    SLABS OBJ/SLAB CACHE SIZE NAME                   
> 1070187012      0   0%    0.14K 39636556       27 158546224K 
> ext4_alloc_context
> 

and it's all unused... (inactive)

To make matters worse drop_caches doesn't touch the slabs, IIRC, but you
might try: echo 3 > /proc/sys/vm/drop_caches

> I see no reason why ext4 should use so much memory. What is it used for? And 
> how can I release it to get it used for my processes.

You may need to reboot, or at best unmount ext4 filesystems and/or rmmod
the ext4 module, if the drop_caches trick doesn't work.

The fact that this doesn't get reclaimed seems to point to a problem
with the vm though, I think (aside from the craziness of ext4 using
this slab so heavily without my patch...)

-Eric
