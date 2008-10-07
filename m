From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 deadlocks
Date: Tue, 07 Oct 2008 16:27:36 -0500
Message-ID: <48EBD448.1010309@redhat.com>
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYJGVbp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Oct 2008 17:31:45 -0400
In-Reply-To: <48EBC6B9.7000608@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Jeremy Fitzhardinge wrote:
>> I tried giving ext4 a spin on my rawhide system, and it appears to 
>> deadlock pretty quickly: lots of processed blocked in either ext4 or jbd2.
>>
>>  From the look of the sysrq-t dumps I captured, I think beagled is 
>> what's triggering it by doing something with EAs. I haven't had any 
>> lockups since I killed it off.
>>

ok I can reproduce this too.  I'm guessing this is a migrated ext3
filesystem?

I'll sort out a fix soon.

Thanks for the report,
-Eric
