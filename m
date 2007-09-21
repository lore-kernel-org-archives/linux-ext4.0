From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Introduce ext4_find_next_bit
Date: Fri, 21 Sep 2007 14:38:33 +0530
Message-ID: <46F38A11.5040803@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46F36801.3070908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44839 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXIUJJP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 05:09:15 -0400
In-Reply-To: <46F36801.3070908@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Balbir Singh wrote:
> Aneesh Kumar K.V wrote:
>> Also add generic_find_next_le_bit
>>
>> This gets used by the ext4 multi block allocator patches.
>>
> 
> Looks like it's a straight forward on Little Endian Architectures.
> I see something for powerpc, what about other architectures?
> 
>
All include/asm-<arch>/bitops.h except powerpc have 

#include <asm-generic/bitops/ext2-non-atomic.h>

and ext2-non-atomic.h have #include <asm-generic/bitops/le.h>


-aneesh
