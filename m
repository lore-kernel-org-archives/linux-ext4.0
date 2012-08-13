From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: don't load the block bitmap for block groups which
 have no space
Date: Mon, 13 Aug 2012 13:51:16 -0500
Message-ID: <50294CA4.90100@redhat.com>
References: <20120809181059.A5BAA11FC69@bugzilla.kernel.org> <1344622885-14982-1-git-send-email-tytso@mit.edu> <50292500.1070807@redhat.com> <20120813184916.GF32484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab2HMSvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 14:51:19 -0400
In-Reply-To: <20120813184916.GF32484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/13/12 1:49 PM, Theodore Ts'o wrote:
> On Mon, Aug 13, 2012 at 11:02:08AM -0500, Eric Sandeen wrote:
>>
>> Looks ok to me; I think this just further optimizes what was done
>> in
>>
>> 8a57d9d61a6e361c7bb159dda797672c1df1a691
>> ext4: check for a good block group before loading buddy pages
>>
>> correct?
> 
> Yes, that's right; it's a further optimization.
> 
> I can think of an additional optimization where if we are reading the
> block bitmap for block group N, and the block bitmap for block group
> N+1 hasn't been read before (so we don't have buddy bitmap stats), and
> the block bitmap for bg N+1 is adjacent for bg N, we should read both
> at the same time.  (And this could be generalized for N+2, N+3, etc.)
> 
> I'm not entirely sure whether it's worth the effort, but I suspect for
> very full file systems, it might be very well be.  This is a more
> general case of the problem where most people only benchmark mostly
> empty file systems, and my experience has been that above 70-80%
> utilization, our performance starts to fall off.  And while disk space
> is cheap, it's not _that_ cheap, and there are always customers who
> insist on using file systems up to a utilization of 99%, and expect
> the same performance as when the file system was freshly formated.  :-(

I did some tests w/ very large filesystems, fallocating 1T at a time until
full.  ext4 tended to fall down pretty badly towards the end.  Anything that
can reduce the time it takes to find free blocks as a very large filesystem
fills would probably be useful....

-eric

> 	    	 	     	     	 - Ted
> 

