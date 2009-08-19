From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Block allocation failed
Date: Wed, 19 Aug 2009 10:25:30 -0500
Message-ID: <4A8C196A.9060801@redhat.com>
References: <87iqgk8jal.fsf@newton.gmurray.org.uk>	<20090819135006.GB17488@mit.edu> <87zl9vhnfa.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37808 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752020AbZHSPZi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 11:25:38 -0400
In-Reply-To: <87zl9vhnfa.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Graham Murray wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
>> On Wed, Aug 19, 2009 at 06:27:46AM +0100, Graham Murray wrote:
>>> Shortly after rebooting following an untidy shutdown due to an unrelated
>>> (to ext4 or the filesystem) Oops. Unmounting the partition and running
>>> e2fsck (version 1.41.8) just replayed the journal and stated the
>>> filesystem was clean but I did not believe it so ran 'e2fsck -f
>>> /dev/sdb3' and that showed several errors which I allowed it to correct.
>> What sort of errors did it find?
>>
> Sorry, but I do not remember all the errors, it was late at night. The
> first were some sort of block error with lots of block numbers in ()
> which I responded 'y' to fix. 

Probably something like this:

Block bitmap differences:  +(32768--34306) +(65536--66049)
+(98304--99842) +(131072--131585) +(163840--165378) +(196608--197121) ...

indicating corrupt bitmaps I guess, which would explain the later mismatch.

-Eric
