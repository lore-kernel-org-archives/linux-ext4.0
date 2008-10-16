From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] vmscan: set try_to_release_page's gfp_mask to 0
Date: Thu, 16 Oct 2008 12:06:09 +0900
Message-ID: <6.0.0.20.2.20081016120032.046ec3a0@172.19.0.2>
References: <6.0.0.20.2.20080813111835.03d345b0@172.19.0.2>
 <20080812202127.b88e8250.akpm@linux-foundation.org>
 <6.0.0.20.2.20080813150454.03b13e30@172.19.0.2>
 <20081015153641.afcc94e5.akpm@linux-foundation.org>
 <6.0.0.20.2.20081016112735.04a68e70@172.19.0.2>
 <20081015195458.cc203dd5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41467 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJPDJK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Oct 2008 23:09:10 -0400
In-Reply-To: <20081015195458.cc203dd5.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080813111835.03d345b0@172.19.0.2>
 <20080812202127.b88e8250.akpm@linux-foundation.org>
 <6.0.0.20.2.20080813150454.03b13e30@172.19.0.2>
 <20081015153641.afcc94e5.akpm@linux-foundation.org>
 <6.0.0.20.2.20081016112735.04a68e70@172.19.0.2>
 <20081015195458.cc203dd5.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


At 11:54 08/10/16, Andrew Morton wrote:
>On Thu, 16 Oct 2008 11:44:39 +0900 Hisashi Hifumi 
><hifumi.hisashi@oss.ntt.co.jp> wrote:
>
>> 
>> Unfortunately, I did not succeed to get good performance number that
>> prove this patch had some benefit.
>
>OK, thanks, I dropped it.
>
>> >This patch remains in a stalled state...
>> >
>> >And then there's this:
>> >
>> 
>> >: 
>> >: Really, I think what this patch tells us is that 3f31fddf ("jbd: fix
>> >: race between free buffer and commit transaction") was an unpleasant
>> >: hack which had undesirable and unexpected side-effects.  I think - that
>> >: depends upon your as-yet-undisclosed testing results?
>> >: 
>> >: Perhaps we should revert 3f31fddf and have another think about how to
>> >: fix the direct-io -EIO problem.  One option would be to hold our noses
>> >: and add a new gfp_t flag for this specific purpose?
>> >:
>> 
>> direct-io -EIO problem was already fixed by following patch.
>> 
>> commit 6ccfa806a9cfbbf1cd43d5b6aa47ef2c0eb518fd
>> Author: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>> Date:   Tue Sep 2 14:35:40 2008 -0700
>> 
>>     VFS: fix dio write returning EIO when try_to_release_page fails
>> 
>> Dio falls back to buffered write when dio write gets EIO due to failure 
>of try_to_release_page
>> by above patch. So I think just reverting the patch 3f31fddf ("jbd: fix 
>race between 
>> free buffer and commit transaction") is good approach.
>
>Fair enough.  Could I ask that you (or someone) send a suitable patch
>sometime?

Yes, sometimes I send you some bug fixing or performance improvement
patch.

>
>I could generate the patch, but I'd never get around to testing it. 
>Too busy fixing rejects and compile errors :(

