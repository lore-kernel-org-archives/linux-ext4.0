From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Tue, 19 May 2009 13:53:22 -0500
Message-ID: <4A130022.6090807@redhat.com>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39894 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZESSxb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 14:53:31 -0400
In-Reply-To: <20090519174901.GB9053@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, May 19, 2009 at 07:14:30PM +0200, Jan Kara wrote:
>>> EXT3: Change all super.c messages to print the device
>>>
>>> I had a problem where it was unclear to which device a ext3 message belonged.
>>> Not all of them them print it.
>>>
>>> This patch changes ext3 super.c to include the device name with all 
>>> warning/error messages, by using a new utility function ext3_msg. 
>>> It's a rather large patch, but very mechanic. I left debug printks
>>> alone.
>>>
>>> The normal mount output looks a little more regular now because near all
>>> messages are in the same format.
>>>
>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>   Ted, did you pick up this cleanup? I don't see any reply or the patch
>> being merged... The cleanup looks nice.
> 
> No, I didn't but thanks for reminding me; I agree it's a good cleanup.
> We should get it ported over to ext4, too.

I'll do that, unless anyone's already started.

There's a bit of inconsistency in the patch between:

ext3_msg(sb, KERN_ERR "message");
and
ext3_msg(sb, KERN_ERR, "message");

just FWIW.

-Eric
