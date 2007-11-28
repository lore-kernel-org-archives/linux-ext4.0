From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 still broken on arm (at least)
Date: Wed, 28 Nov 2007 08:45:59 -0800
Message-ID: <474D9B47.80209@us.ibm.com>
References: <20071127211444.703741a9.akpm@linux-foundation.org> <20071128053020.GA6977@skywalker> <20071127214308.5215a6a2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-arch@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48881 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817AbXK1QqF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2007 11:46:05 -0500
In-Reply-To: <20071127214308.5215a6a2.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> On Wed, 28 Nov 2007 11:00:20 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
>> On Tue, Nov 27, 2007 at 09:14:44PM -0800, Andrew Morton wrote:
>>> fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
>>> fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'                                                                             
>>
>> I actually sent in a patch which changes asking for review to
>> linux-arch. I haven't got the response yet.
> 
> Don't expect one...
> 
>> Attaching the patch
>> below 
> 
> 
>> Introduce ext4_find_next_bit
>>
>> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>> This gets used by the ext4 multi block allocator patches.
>>
>> Also add generic_find_next_le_bit
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Cc: <linux-ext4@vger.kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  include/asm-arm/bitops.h                     |    2 +
>>  include/asm-generic/bitops/ext2-non-atomic.h |    2 +
>>  include/asm-generic/bitops/le.h              |    4 ++
>>  include/asm-m68k/bitops.h                    |    2 +
>>  include/asm-m68knommu/bitops.h               |    2 +
>>  include/asm-powerpc/bitops.h                 |    4 ++
>>  include/asm-s390/bitops.h                    |    2 +
>>  include/linux/ext4_fs.h                      |    1 +
>>  lib/find_next_bit.c                          |   43 ++++++++++++++++++++++++++
> 
> May as well merge it I guess.  I'll do that.  Possibly it should be
> merged into the ext4 tree instead, so that people can build the ext4 devel
> tree on other architectures but obviously there's no call for that.
> 
I will merge it to ext4 development tree.

Mingming
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
