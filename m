From: Brian Gitonga Marete <marete@toshnix.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this function
Date: Tue, 2 Nov 2010 23:08:40 +0300
Message-ID: <AANLkTikyzuPQB_b5rE732ntcK6F24ZbBR7K0t7R7Urvb@mail.gmail.com>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de>
	<alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
	<20101102182911.GE25614@thunk.org>
	<AANLkTim9JbCk29oPjrYMSfhtHL4tL4uHtDq_xZoe7tzg@mail.gmail.com>
	<alpine.LFD.2.00.1011021516470.16869@dhcp-lab-213.englab.brq.redhat.com>
	<4CD06B45.2070704@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Lukas Czerner <lczerner@redhat.com>,
	kevin granade <kevin.granade@gmail.com>,
	"Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CD06B45.2070704@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Indeed. In clause 4 of Section 6.5.13 of C99, short circuit evaluation
is guaranteed in addition to left to right evaluation.

On 11/2/10, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Lukas Czerner wrote:
>> On Tue, 2 Nov 2010, kevin granade wrote:
>>> +                       if (time_after_eq(jiffies, elr->lr_next_sched) &&
>>> +                           ext4_run_li_request(elr) != 0) {
>>> +                               /* error, remove the lazy_init job */
>>> +                               ext4_remove_li_request(elr);
>>> +                               continue;
>>>                        }
>>>
>>>                        if (time_before(elr->lr_next_sched, next_wakeup))
>>> --
>>>
>>> Though obviously it's a pretty subjective style issue.
>>> Kevin Granade
>>
>> Hmm this relies on the fact that if the first part of the condition
>> would not be true, the second part (after and) would never be invoked,
>> however I am not really sure that we can rely on that on every
>> architecture, or can we ?
>
> It is not about architecture but a C language feature.  It is relied upon
> everywhere in the kernel.  For example,
>
> 	if (p != NULL && p->m == something) {
> 		...
>
> is very common.  The || operator has the same property:  Evaluation stops as
> soon as the end result is known.  I do not know since when this minimum
> evaluation feature is guaranteed in the language, but it has to be ages now.
>
> (This is not an endorsement of one or the other coding of the patch. :-)
> --
> Stefan Richter
> -=====-==-=- =-== ---=-
> http://arcgraph.de/sr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
