From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: Re: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Fri, 06 Jun 2008 09:57:48 +0300
Message-ID: <4848DFEC.1010800@movial.fi>
References: <20080512130604.GA15008@deprecation.cyrius.com> <90edad820805120654n50f7a00cm3c7b4a4f9346d5ea@mail.gmail.com> <20080512143426.GB7029@mit.edu> <90edad820805120746l61e67362vbd177d63e8b05dc8@mail.gmail.com> <20080513045028.GC22226@linux-mips.org> <20080528070637.GA10393@deprecation.cyrius.com> <20080605111148.GA4483@deprecation.cyrius.com> <1212664977.4840.6.camel@sd048.hel.movial.fi> <20080605183854.GN25477@mit.edu> <38408.84.249.59.97.1212701650.squirrel@webmail.movial.fi> <20080605215152.GB15504@networkno.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, Martin Michlmayr <tbm@cyrius.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
	linux-mips@linux-mips.org, linux-ext4@vger.kernel.org
To: Thiemo Seufer <ths@networkno.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:34982 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbYFFG5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2008 02:57:45 -0400
In-Reply-To: <20080605215152.GB15504@networkno.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thiemo Seufer wrote:
> Vorobiev Dmitri wrote:
>> Theodore Tso wrote:
>>> If you really insist I suppose we could have a MIPS specific patch
>>> where we allocate a 4k page and zero it, so we can use it from our
>>> kernel code because you don't want to export and make available the
>>> ZERO_PAGE that gets used by the rest of the kernel, but that seems
>>> awfully silly, and would be a waste of 4k of memory.....  Someone from
>>> MIPS land would have to test it, as well, as I dont think any of the
>>> ext4 developers have access to a MIPS platform.
>> Ted, Ralf seems to be unwilling to accept the ZERO_PAGE() export. If you
>> send the MIPS-specific patch, I can do the testing for you as I have a
>> MIPS Malta board at my disposal.
> 
> AFAIU the problematic case are systems with R4000/R4400 SC/MC CPUs
> since they use 8 zero pages of different color. Have a look at
> arch/mips/mm/init.c:setup_zero_pages.

OK, thanks for the info. However, I won't be able to tackle into the
issue during this and the next week as I'm having a business trip.
Therefore, if the issue is urgent, I'd be grateful if someone could take
over.

Thanks,
Dmitri
