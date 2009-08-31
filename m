From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 	document conditions when reliable operation is possible)
Date: Mon, 31 Aug 2009 18:19:25 -0500
Message-ID: <4A9C5A7D.8000302@cox.net>
References: <4A947682.2010204@redhat.com> <4A967175.5070700@redhat.com>	 <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>	 <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>	 <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu>	 <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>	 <20090831180746.GA32110@piper.oerlikon.madduck.net> <4807377b0908311526r3b42f581j27b9c26166b7ac96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Linux-Ext4 <linux-ext4@vger.kernel.org>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao102.cox.net ([68.230.240.8]:49508 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZHaXTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 19:19:24 -0400
In-Reply-To: <4807377b0908311526r3b42f581j27b9c26166b7ac96@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-08-31 17:26, Jesse Brandeburg wrote:
> On Mon, Aug 31, 2009 at 11:07 AM, martin f krafft<madduck@debian.org> wrote:
>> also sprach Jesse Brandeburg <jesse.brandeburg@gmail.com> [2009.08.31.1949 +0200]:
>>> In the case of a degraded array, could the kernel be more
>>> proactive (or maybe even mdadm) and have the filesystem remount
>>> itself withOUT journalling enabled?  This seems on the surface to
>>> be possible, but I don't know the internal particulars that might
>>> prevent/allow it.
>> Why would I want to disable the filesystem journal in that case?
> 
> I misspoke w.r.t journalling, the idea I was trying to get across was
> to remount with -o sync while running on a degraded array, but given
> some of the other comments in this thread I'm not even sure that would
> help.  the idea was to make writes as safe as possible (at the cost of
> speed) when running on a degraded array, and to have the transition be
> as hands-free as possible, just have the kernel (or mdadm) by default
> remount.

Much better, I'd think, to "just" have it scream out DANGER!! WILL 
ROBINSON!! DANGER!! to syslog and to an email hook.

-- 
Brawndo's got what plants crave.  It's got electrolytes!
