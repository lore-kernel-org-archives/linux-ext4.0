From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Introduce ext4_find_next_bit
Date: Wed, 14 Nov 2007 00:41:03 +0530
Message-ID: <4739F6C7.90408@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071112235910.35a635e4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760884AbXKMTLp@vger.kernel.org>
In-Reply-To: <20071112235910.35a635e4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andrew Morton wrote:
> On Fri, 21 Sep 2007 10:55:05 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
>> Also add generic_find_next_le_bit
>>
>> This gets used by the ext4 multi block allocator patches.
>>
> 
> arm allmodconfig:
> 
> fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
> fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'
> 
> This patch makes my head spin.
> 
> Why did we declare generic_find_next_le_bit() in
> include/asm-powerpc/bitops.h (wrong) as well as in
> include/asm-generic/bitops/le.h (presumably correct)?
> 

I was following the coding style used for rest of the APIs
like ext4_set_bit.


> Why is it touching a powerpc file and no any other architectures? 
> Something screwed up in powerpc land?
> 
> And why did arm break?

arm and below list of arch doesn't include the asm-generic/bitops/ext2-non-atomic.h 

I did a grep and that list the below architectures as also affected.
arm, m68k, m68knommu, s390

> 
> Shudder.  Anyway, please fix, and if that fix requires that various
> braindamaged be repaired, please repair the braindamage rather than going
> along with it.
> 
> 

That should be a separate patch altogether. I wanted to do the cleanup
along with the usages such as but never got time to do the same.

#define ocfs2_set_bit ext2_set_bit
#define udf_set_bit(nr,addr) ext2_set_bit(nr,addr)
direct usage in mb
md/bitmap.c +799
md/dm-log.c +177

I will send a patch tomorrow that fix  arm and other architectures. I guess the cleanup
can be a separate patch ? 

-aneesh
