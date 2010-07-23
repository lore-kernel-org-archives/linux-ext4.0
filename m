From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Ext4: batched discard support - simplified version
Date: Fri, 23 Jul 2010 11:40:58 -0400
Message-ID: <x49bp9yjjed.fsf@segfault.boston.devel.redhat.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
	<20100723143604.GF13090@thunk.org>
	<x49hbjqjknj.fsf@segfault.boston.devel.redhat.com>
	<20100723151925.GI13090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	rwheeler@redhat.com, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0GWPlC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 11:41:02 -0400
In-Reply-To: <20100723151925.GI13090@thunk.org> (Ted Ts'o's message of "Fri,
	23 Jul 2010 11:19:25 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Ted Ts'o" <tytso@mit.edu> writes:

> On Fri, Jul 23, 2010 at 11:13:52AM -0400, Jeff Moyer wrote:
>> 
>> I don't think so.  In all of the configurations tested, I'm pretty sure
>> we saw a performance hit from doing the TRIMs right away.  The queue
>> flush really hurts.  Of course, I have no idea what you had in mind for
>> the amount of time in between batched discards.
>
> Sure, but not all the world is SATA-attached SSD's.  I'm thinking in
> particular of PCIe-attached SSD's, where the TRIM command might be
> very fast indeed...  I believe Ric Wheeler tells me you have TMS
> RamSan SSD's in house that you are testing?  And of course those
> aren't the only PCIe-attached flash devices out there....

You are right, and we have to consider thinly provisioned luns, as well.
The only case I can think of where it makes sense to issue those
discards immediately is if you are running tight on allocated space in
your thinly provisioned lun.  Aside from that, I'm not sure why you
would want to send those commands down with every journal commit,
instead of batched daily, for example.  But, I can certainly understand
wanting to allow this flexibility.

Cheers,
Jeff
