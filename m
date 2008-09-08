From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] make all feature-related printks KERN_INFO and print
 barrier status as well
Date: Mon, 08 Sep 2008 16:20:58 -0500
Message-ID: <48C5973A.8000007@redhat.com>
References: <48C55C0E.2050809@redhat.com> <20080908211047.GN8161@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYIHVWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2008 17:22:43 -0400
In-Reply-To: <20080908211047.GN8161@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Sep 08, 2008 at 12:08:30PM -0500, Eric Sandeen wrote:
>> A very trivial little tidy-up patch.
>>
>> This slightly duplicates a little of
>> patches/ext4_fix_printk_checkpatch_issues but just in one hunk,
>> easily fixed up.
>>
>> Various feature printk's come out at different levels, so for example
>> at my default logging level I see mballoc & extents messages, but
>> not delalloc, even though they are all on.
>>
>> Also, since default barrier behavior has changed, I thought perhaps always
>> printing the barrier state might be a good idea.
> 
> Looks good to me.  Any reason not to merge it with the
> ext4_fix_printk_checkpatches_issues?  Actually what I was thinking
> about doing was to segregate out all of the printk level issues from
> everything else, just to make it easier to understand/audit the
> cleanup patch(es).
> 
> 							- Ted

Sure, it could be merged.  The patch I sent actually changed some
behavior, and was limited to mount-time feature prints, so thought it
might make sense on its own.

Either way is fine by me.

-Eric
