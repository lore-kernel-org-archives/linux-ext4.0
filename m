From: jim owens <jowens@hp.com>
Subject: Re: [patch] document flash/RAID dangers
Date: Sat, 29 Aug 2009 12:12:12 -0400
Message-ID: <4A99535C.4070104@hp.com>
References: <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A94B8FE.8050307@redhat.com> <20090826112219.GE26595@elf.ucw.cz> <4A954A98.5070808@redhat.com> <20090829093947.GE1634@ucw.cz> <4A99154C.7050503@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, corbet@lwn.net
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1893 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH2QMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Aug 2009 12:12:53 -0400
In-Reply-To: <4A99154C.7050503@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ron Johnson wrote:
> On 2009-08-29 04:39, Pavel Machek wrote:
>> Noone told me that degraded md raid5 is dangerous. Thats documentation
>> issue #1. Maybe I just pulled the disk for fun.
> 
> You're kidding, right?

No he is not... and that is exactly why Ted and Ric have been
fighting so hard against his scare the children documentation.

In 20 years, I have not found a way to educate those who think
"I know computers so it must work the way I want and expect."

Tremendous amounts of information and recommendations are out
there on the web, in books, classes, etc.  But people don't
research before using or understand before they have a problem.

Pavel Machek wrote:
> It is not only for system administrators; I was trying to find
> out if kernel is buggy, and that should be in kernel tree.

Pavel, *THE KERNEL IS NOT BUGGY* end of story!

Everyone experienced in storage understands the "in the
edge case that Pavel hit, you will loose your data", and we
take our responsibility to tell people what works and does
not work very seriously.  And we try very hard to reduce the
amount of edge case data losses.

But as Ric and Ted and many others keep trying to explain:

- There is no such thing as "never fails" data storage.

- The goal of journal file systems is not what you thing.

- The goal of raid is not what you think.

- We do not want the vast majority of computer users who
   are not kernel engineers to stop using the technology
   that in 99.99 percent of the use cases keeps their data
   as safe as we can reasonably make it, just because they
   read Pavel's 0.01 percent scary and inaccurate case.

And the worst part is this 0.01 percent case problem
is really "I did not know what I was doing".

jim

