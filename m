From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Use slab allocator for sub-page sized allocations
Date: Sat, 05 Dec 2009 00:43:13 -0600
Message-ID: <4B1A0101.4090605@redhat.com>
References: <1259716451-26901-1-git-send-email-tytso@mit.edu> <1259716451-26901-2-git-send-email-tytso@mit.edu> <4B169B86.4040707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZLEGnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Dec 2009 01:43:17 -0500
In-Reply-To: <4B169B86.4040707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Theodore Ts'o wrote:
>> Now that the SLUB seems to be fixed so that it respects the requested
>> alignment, use kmem_cache_alloc() to allocator if the block size of
>> the buffer heads to be allocated is less than the page size.
>> Previously, we were using 16k page on a Power system for each buffer,
>> even when the file system was using 1k or 4k block size.
> 
> So, this undoes commit c089d490dfbf53bc0893dc9ef57cf3ee6448314d
> more or less, right:
> 
> JBD: Replace slab allocations with page allocations
> 
> Author: Mingming Cao <cmm@us.ibm.com>
> 
> JBD allocate memory for committed_data and frozen_data from slab. However
> JBD should not pass slab pages down to the block layer.
> Use page allocator pages instead. This will also prepare JBD for the large blocksize patchset.
> 
> Was alignment the only reason that commit went in?

Actually, Christoph reminded me that iscsi & co will not like this.

See commit 1fa40b01ae4d1b00e366d4949edcc230f5cd6d99 for xfs moving
in the opposite direction back in 2007...

-Eric
