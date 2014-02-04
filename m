From: Luca Ognibene <luca.ognibene@gmail.com>
Subject: Re: same ext4 file system corruption on different machines
Date: Tue, 04 Feb 2014 10:05:23 +0100
Message-ID: <1391504723.2663.4.camel@snow.station>
References: <1390999955.2601.22.camel@snow.station>
	 <1391000743.2601.26.camel@snow.station> <20140129173826.GA30419@thunk.org>
	 <1391068749.2680.6.camel@snow.station> <20140131030028.GB7118@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63765 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaBDJF2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Feb 2014 04:05:28 -0500
In-Reply-To: <20140131030028.GB7118@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Il giorno gio, 30/01/2014 alle 22.00 -0500, Theodore Ts'o ha scritto:
> On Thu, Jan 30, 2014 at 08:59:09AM +0100, Luca Ognibene wrote:
> > Yes it's indeed very strange.. i tend to rule out application errors
> > because i don't write directly to the device so i don't think i can
> > break a filesystem from userspace. I've checked previous and next blocks
> > and they seem ok, only the block 524320 is getting corrupted. Any idea
> > on what should i look for now?
> 
> Are you willing to try 3.12.9 or 3.13.1 upstream kernel?  Let's see if
> changing the kernel makes any difference.  I don't recall any ext4
> problems like this, but maybe it's device driver problem.

I'll try but my problem is that i can't replicate it.. i have to wait
weeks to see it happen on clients machines.

> The other thing I'd ask is whether you can swap out the hard drive
> interface --- can you use a USB 3.0 attached drive, or something like
> that?

I can't do that, sorry.

ciao
Luca

