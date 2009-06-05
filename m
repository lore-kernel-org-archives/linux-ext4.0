From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 13:12:47 -0500
Message-ID: <4A29601F.3070802@redhat.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37414 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZFESMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 14:12:50 -0400
In-Reply-To: <4A294B15.9070209@tuffmail.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alan Jenkins wrote:
> Eric Sandeen wrote:

>> Maybe you could try some things in your shutdown script, such as
>> explicitly fsyncing the file, or bmapping it with filefrag, or dropping
>> caches and rereading it... see what the state is just before the
>> shutdown compared to after the reboot.
>>
>> -Eric
>>   
> 
> Dropping caches (and running sync first) had no effect on the result of 
> md5sum.  Hopefully that narrows it down a bit.

And did the reread after dropping caches have the right data?

Did the block numbers reported by filefrag -v change post-boot?

-Eric
