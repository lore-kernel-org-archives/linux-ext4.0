From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Wed, 24 Jun 2009 11:39:02 -0500
Message-ID: <4A4256A6.7070707@redhat.com>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com> <20090621004919.GA6798@mit.edu> <4A42513C.6020607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45033 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZFXQjC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 12:39:02 -0400
In-Reply-To: <4A42513C.6020607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Tso wrote:

...

>> I can see some things we can do to optimize stack usage; for example,
>> struct ext4_allocation_request is allocated on the stack, and the
>> structure was laid out without any regard to space wastage caused by
>> alignment requirements.  That won't help on x86 at all, but it will
>> help substantially on x86_64 (since x86_64 requires that 8 byte
>> variables must be 8-byte aligned, where as x86_64 only requires 4 byte
>> alignment, even for unsigned long long's).  But it's going have to be
>> a whole series of incremental improvements; I don't see any magic
>> bullet solution to our stack usage.
> 
> XFS forces gcc to not inline any static function; it's extreme, but
> maybe it'd help here too.

Giving a blanket noinline treatment to mballoc.c yields some significant
stack savings:

-ext4_mb_free_blocks 200
+ext4_mb_free_blocks 184

-ext4_mb_init_cache 232
+ext4_mb_init_cache 136

-ext4_mb_regular_allocator 232
+ext4_mb_regular_allocator 104

-ext4_mb_new_blocks 104
(drops below 100 bytes)

-Eric

