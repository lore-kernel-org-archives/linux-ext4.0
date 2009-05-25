From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: zero out blocks of freed user data for operation a virtual machine environment
Date: Mon, 25 May 2009 15:14:02 +0200
Message-ID: <87ab51qq91.fsf@frosties.localdomain>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
	<20090524101551.57b706e9@infradead.org>
	<20090524173933.GD24753@cip.informatik.uni-erlangen.de>
	<20090525120320.GA25908@mit.edu>
	<20090525123430.GA5534@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57405 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZEYNOC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2009 09:14:02 -0400
In-Reply-To: <20090525123430.GA5534@cip.informatik.uni-erlangen.de> (Thomas
	Glanzmann's message of "Mon, 25 May 2009 14:34:30 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thomas Glanzmann <thomas@glanzmann.de> writes:

> Hello Ted,
>
>> Yes, it does, sb_issue_discard().  So if you wanted to hook into this
>> routine with a function which issued calls to zero out blocks, it
>> would be easy to create a private patch.
>
> that sounds good because it wouldn't only target the most used
> filesystem but every other filesystem that uses the interface as well.
> Do you think that a tunable or configurable patch has a chance to hit
> upstream as well?
>
>         Thomas

I could imagine a device mapper target that eats TRIM commands and
writes out zeroes instead. That should be easy to maintain outside or
inside the upstream kernel source.

MfG
        Goswin
