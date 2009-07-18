From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
 all .data.* sections on X86_64)
Date: Sat, 18 Jul 2009 23:33:35 +0100
Message-ID: <1247956415.4236.9.camel@toshiba-laptop>
References: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
	 <1247574390.28240.67.camel@pc1117.cambridge.arm.com>
	 <20090715080336.GA4823@skywalker> <4A5D9939.3000500@fisher-privat.net>
	 <20090718115556.GA31007@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-ext4@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37507 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964AbZGRWeM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 18:34:12 -0400
In-Reply-To: <20090718115556.GA31007@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2009-07-18 at 13:55 +0200, Ingo Molnar wrote:
> * Alexey Fisher <bug-track@fisher-privat.net> wrote:
> 
> > This patch work for me.
> 
> nice. Any leftovers that might be false positives and need 
> annotation?

With the latest mainline all the reports I get look like real leaks but
some of them are pretty difficult to debug. I have a kmemleak
development tree as well which, among other things like more
cond_resched() calls, scans all the task stacks (currently using
for_each_process) but it doesn't reduce the number of reports.

> We learned this with lockdep: the moment a typical x86 distro bootup 
> is 'warnings free', utility of the debugging facility increases 
> dramatically: people can standardize on 'kmemleak should never 
> produce warnings' workflows and distros can also start feeding 
> kmemleak reports into kerneloops.org or so.

Yes. It's also easy to identify recent commits causing leaks but
currently it looks like some of the have been around for some time
(though probably not so serious leaks).

-- 
Catalin

