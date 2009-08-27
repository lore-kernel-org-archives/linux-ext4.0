From: Pavel Machek <pavel@ucw.cz>
Subject: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Fri, 28 Aug 2009 00:13:21 +0200
Message-ID: <20090827221319.GA1601@ucw.cz>
References: <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53486 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZH0WNa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 18:13:30 -0400
Content-Disposition: inline
In-Reply-To: <4A967175.5070700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>>> Repeat experiment until you get up to something like google scale or the
>>> other papers on failures in national labs in the US and then we can have an
>>> informed discussion.
>>>      
>> On google scale anvil lightning can fry your machine out of a clear sky.
>>
>> However, there are still a few non-enterprise users out there, and knowing
>> that specific usage patterns don't behave like they expect might be useful to
>> them.
>
> You are missing the broader point of both papers. They (and people like  
> me when back at EMC) look at large numbers of machines and try to fix  
> what actually breaks when run in the real world and causes data loss.  
> The motherboards, S-ATA controllers, disk types are the same class of  
> parts that I have in my desktop box today.
...
> These errors happen extremely commonly and are what RAID deals with well.
>
> What does not happen commonly is that during the RAID rebuild (kicked  
> off only after a drive is kicked out), you push the power button or have  
> a second failure (power outage).
>
> We will have more users loose data if they decide to use ext2 instead of  
> ext3 and use only single disk storage.

So your argument basically is

'our abs brakes are broken, but lets not tell anyone; our car is still
safer than a horse'.

and

'while we know our abs brakes are broken, they are not major factor in
accidents, so lets not tell anyone'.

Sorry, but I'd expect slightly higher moral standards. If we can
document it in a way that's non-scary, and does not push people to
single disks (horses), please go ahead; but you have to mention that
md raid breaks journalling assumptions (our abs brakes really are
broken).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
