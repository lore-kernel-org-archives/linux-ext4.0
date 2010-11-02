From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
Date: Tue, 02 Nov 2010 20:49:25 +0100
Message-ID: <4CD06B45.2070704@s5r6.in-berlin.de>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com> <20101102182911.GE25614@thunk.org> <AANLkTim9JbCk29oPjrYMSfhtHL4tL4uHtDq_xZoe7tzg@mail.gmail.com> <alpine.LFD.2.00.1011021516470.16869@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kevin granade <kevin.granade@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56082 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab0KBTto (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Nov 2010 15:49:44 -0400
In-Reply-To: <alpine.LFD.2.00.1011021516470.16869@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lukas Czerner wrote:
> On Tue, 2 Nov 2010, kevin granade wrote:
>> +                       if (time_after_eq(jiffies, elr->lr_next_sched) &&
>> +                           ext4_run_li_request(elr) != 0) {
>> +                               /* error, remove the lazy_init job */
>> +                               ext4_remove_li_request(elr);
>> +                               continue;
>>                        }
>>
>>                        if (time_before(elr->lr_next_sched, next_wakeup))
>> --
>>
>> Though obviously it's a pretty subjective style issue.
>> Kevin Granade
> 
> Hmm this relies on the fact that if the first part of the condition
> would not be true, the second part (after and) would never be invoked,
> however I am not really sure that we can rely on that on every
> architecture, or can we ?

It is not about architecture but a C language feature.  It is relied upon
everywhere in the kernel.  For example,

	if (p != NULL && p->m == something) {
		...

is very common.  The || operator has the same property:  Evaluation stops as
soon as the end result is known.  I do not know since when this minimum
evaluation feature is guaranteed in the language, but it has to be ages now.

(This is not an endorsement of one or the other coding of the patch. :-)
-- 
Stefan Richter
-=====-==-=- =-== ---=-
http://arcgraph.de/sr/
