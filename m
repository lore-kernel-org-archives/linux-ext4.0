From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: remove unaligned AIO warning printk
Date: Wed, 21 Nov 2012 14:03:17 -0600
Message-ID: <50AD3385.1030500@redhat.com>
References: <50AD09F0.6090706@redhat.com> <20121121194728.GA6895@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016Ab2KUUDU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 15:03:20 -0500
In-Reply-To: <20121121194728.GA6895@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/21/12 1:47 PM, Theodore Ts'o wrote:
> On Wed, Nov 21, 2012 at 11:05:52AM -0600, Eric Sandeen wrote:
>> Although I put this in, I now think it was a bad decision.
>> For most users, there is very little to be done in this case.  They
>> get the message, once per day, with no real context or proposed action.
>> TBH, it generates support calls when it probably does not need to;
>> the message sounds more dire than the situation really is.
>>
>> Just nuke it.  Normal investigation via blktrace or whatnot can
>> reveal poor IO patterns if bad performance is encountered.
> 
> I wonder if this might be a good thing to enable or disable via sysfs
> tuning knob, just to make it a little easier for a random application
> developer to test for this?

*shrug* would be more knobs & more complexity; I bet 99% of people reporting
it would never have known the knob was there, and doubtful they'd have turned
it on.  If developers cared, they'd probably have done the proper thing in the
first place.  I guess I'm skeptical of the usefulness.

> And do you have a list of the bad applications so we can nag them to
> fix them?

Whenever we get it reported, it's some proprietary thing.  So no, not
really, I'm afraid.

But google live search thinks it's virtualbox, kvm, and java ;)

"Unaligned AIO/DIO on inode" turns up plenty.

Can you do some sort of google-grep-awk to find every app that's been
reported on lists?  ;)

-Eric

> 					- Ted
> 


