From: jim owens <jowens@hp.com>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Wed, 02 Sep 2009 20:36:10 -0400
Message-ID: <4A9F0F7A.1010805@hp.com>
References: <20090826001645.GN4300@elf.ucw.cz> <20090902201210.GC1840@ucw.cz> <4A9ED8AB.5080003@redhat.com> <200909021800.51096.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:24374 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZICAgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 20:36:12 -0400
In-Reply-To: <200909021800.51096.rob@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rob Landley wrote:
> On Wednesday 02 September 2009 15:42:19 Ric Wheeler wrote:
>>
>> Totally pointless to reply to you further.
> 
> For the record, I've been able to follow Pavel's arguments, and I've been able 
> to follow Ted's arguments.  But as far as I can tell, you're arguing about a 
> different topic than the rest of us.

I had no trouble following what Ric was arguing about.

Ric never said "use only the best devices and you won't have problems".

Ric was arguing the exact opposite - ALL devices are crap if you define
crap as "can loose data".  What he is saying is you need to UNDERSTAND
your devices and their behavior and you must act accordingly.

PAVEL DID NOT ACT ACCORDING TO HIS DEVICE LIMITATIONS.

We understand he was clueless, but user error is still user error!

And Ric said do not stigmatize whole classes of A) devices, B) raid,
and C) filesystems with "Pavel says...".

> However, thinking about how to _fix_ a problem is predicated on acknowledging 
> that there actually _is_ a problem.  "The hardware is not physically damaged 
> but your data was lost" sounds to me like a software problem, and thus 
> something software could at least _attempt_ to address.  "There's millions of 
> 'em, Linux can't cope" doesn't seem like a useful approach.

We have been trying forever to deal with device problems and as
Ric kept trying to explain we do understand them.  The problem is
not "can we be better" it is "at what cost".  As they keep saying
"fast", "cheap", "safe"... pick any 2.  Adding software solutions
to solve it will always turn "fast" to "slow".

Most people will choose some risk they can manage (such as
don't pull the flash card you idiot), instead of snail slow.

> I already addressed the software raid thing last post.

Saw it. I am not an MD guy so I will not say anything bad about it
except all the "journal" crud.  It really is only pandering to Pavel
because ALL filesystems can be screwed and that is what they really
need to know.  The journal stuff distracts those who are not running
a journaling filesystem, even if your description is correct except
that as we fs people keep saying, fsck is meaningless and again will
only give you a false sense of security that your data is OK.

jim
