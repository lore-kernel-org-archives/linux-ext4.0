From: Sev Binello <sev@bnl.gov>
Subject: Re: e2fsck and human intervention
Date: Mon, 05 Mar 2007 12:42:51 -0500
Message-ID: <45EC569B.3010608@bnl.gov>
References: <1173112017.6300.14.camel@systems03.mmm.com> <20070305164847.GB9444@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Daniel Drake <ddrake@brontes3d.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpout.bnl.gov ([130.199.3.136]:18461 "EHLO smtpout.bnl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbXCERuE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 12:50:04 -0500
Received: from smtpgateway3.bnl.vip ([172.16.1.67] helo=smtpgateway.bnl.gov)
	by smtpout.bnl.gov with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(SMTP out virtual0)
	serial 1HOHJz-0007V1-Ja
	for linux-ext4@vger.kernel.org; Mon, 05 Mar 2007 12:50:03 -0500
In-Reply-To: <20070305164847.GB9444@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Mon, Mar 05, 2007 at 11:26:57AM -0500, Daniel Drake wrote:
>   
>> Hi,
>>
>> I'm working with ext3 partitions in a product environment, where
>> numerous embedded Linux systems will be shipped to various locations.
>>
>> In testing we occasionally find that system boot is halted by e2fsck
>> with an "UNEXPECTED INCONSISTENCY" error message. This is while running
>> in preen mode.
>>
>> This usually happens during e2fsck's regular "check every X mounts"
>> thing, as opposed to immediately after booting up after power loss, so
>> to begin with it's not immediately obvious why there is a problem.
>>
>> It's of course understandable and inevitable that power loss will
>> occasionally cause some file loss or corruption, and that's fine. My
>> main concern is that fsck is halting the boot process, and in a product
>> scenario this would require an engineer to perform a service call. If
>> e2fsck could unconditionally perform a best-effort attempt at solving
>> the problems, it would be ideal.
>>     
>
> Actually, power loss by itself should *not* cause any corruption when
> you are using ext3; that's the whole point of the journal.  If there
> is, you probably have some other problem that you might do well to try
> to debug before youi ship your product, since that may lead to
> significant data loss in the long-term.
>
>   
*So when and why is an fsck necessary ?*
>> Are there any better approaches than something like the following?
>>
>> 1. Run "e2fsck -p /"
>>
>> 2. If bit 3 is set in exit code (i.e. preen functionality detected
>> unexpected inconsistency) then run "e2fsck -y /"
>>
>> Is there significant risk of further data loss through using -y than
>> might be experienced otherwise?
>>     
>
> You could do this, but if you are using ext3, this is really papering
> over the problem.  With ext3, there really should not be any
> corruptions caused by power loss.  
>
> What sort of errors are being reported by e2fsck?
>
> 							- Ted
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   



-- 

Sev Binello
Brookhaven National Laboratory
Upton, New York
631-344-5647
sev@bnl.gov
