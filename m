From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/11] rbtree: Fix rbtree_postorder_for_each_entry_safe()
 iterator
Date: Thu, 07 Nov 2013 13:58:15 -0800
Message-ID: <527C0CF7.705@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com> <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com> <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Seth Jennings <sjennings@variantweb.net>,
	LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:59649 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3KGV6Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Nov 2013 16:58:24 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Thu, 7 Nov 2013 14:58:23 -0700
In-Reply-To: <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/07/2013 01:38 PM, Andrew Morton wrote:
> On Wed,  6 Nov 2013 17:42:30 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>
>> The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
>> underflow behavior when testing for loop termination. In particular
>> it expects that
>>    &rb_entry(NULL, type, field)->field
>> is NULL. But the result of this expression is not defined by a C standard
>> and some gcc versions (e.g. 4.3.4) assume the above expression can never
>> be equal to NULL. The net result is an oops because the iteration is not
>> properly terminated.
>>
>> Fix the problem by modifying the iterator to avoid pointer underflows.
>
> So the sole caller is in zswap.c.  Is that code actually generating oopses?

I can't reproduce the oopses (at all) with my build/gcc version, but Jan 
has reported seeing them (not in zswap, however).

>
> IOW, is there any need to fix this in 3.12 or earlier?
>

The zswap usage change showed up in 3.12.
In my opinion, it is probably a good idea to apply the fix to 3.12.

