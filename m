From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: htree indexing and 64-bit file systems
Date: Sat, 07 Feb 2009 14:06:56 +0100
Message-ID: <87vdrmiefj.fsf@frosties.localdomain>
References: <20090203222202.GK20654@shell> <20090203233108.GW14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:52937 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZBGNG7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Feb 2009 08:06:59 -0500
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate02.web.de (Postfix) with ESMTP id DD783FA18F68
	for <linux-ext4@vger.kernel.org>; Sat,  7 Feb 2009 14:06:57 +0100 (CET)
Received: from [78.43.226.218] (helo=frosties.localdomain)
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1LVmtd-0003uQ-00
	for linux-ext4@vger.kernel.org; Sat, 07 Feb 2009 14:06:57 +0100
Received: from mrvn by frosties.localdomain with local (Exim 4.69)
	(envelope-from <goswin-v-b@web.de>)
	id 1LVmtd-00019i-3Y
	for linux-ext4@vger.kernel.org; Sat, 07 Feb 2009 14:06:57 +0100
In-Reply-To: <20090203233108.GW14762@mit.edu> (Theodore Tso's message of "Tue,
	3 Feb 2009 18:31:08 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Feb 03, 2009 at 05:22:02PM -0500, Valerie Aurora Henson wrote:
>> I've just been ignoring htree indexing for now, but the regression
>> failure in Ted's rebased 64bit tree looks suspiciously htree-related.
>> 
>> What's the interaction between htree and 64 bit file systems?  What
>> needs to change, if anything?
>
> There shouldn't be any.  The block numbers used in htree are logical
> block numbers (i.e., block 0 is the first block in the directory,
> block 1 is the 2nd block i the directory, etc.)
>
> 						- Ted

What if the directory is REALLY HUGE? :) Say >68.719.476.736 files.

Can ext4 64bit have directories >8TiB?

MfG
        Goswin
