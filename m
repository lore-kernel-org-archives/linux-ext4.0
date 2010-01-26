From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Tue, 26 Jan 2010 21:47:54 +0100
Message-ID: <20100126204754.GA4637@nik-comp.linuxbox.cz>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz>
 <20100122213827.GH21263@thunk.org>
 <20100124071943.GA4407@nik-comp.linuxbox.cz>
 <20100124094853.GA4382@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:48353 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab0AZUre (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 15:47:34 -0500
Content-Disposition: inline
In-Reply-To: <20100124094853.GA4382@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theo,
Actually it's ME who appreciates YOUR efforts ;)
I'm sorry for late reply, I did a lot of testing and I've been a bit
busy lately. 
It's getting quite weird. I  can 100% reproduce it.
BUT - the thing is, I can reproduce it only on external eSATA box with
long eSATA cable. I've tried it on two different machines, and with
two different disk boxes. Using shorter cabling seems to fix the problem.
I'd just close the problem stating that it's caused byt crappy cable,
but what worries me is why it was working with older kernels?
Does it mean our backups were just silently being damaged and new
kernel somehow detects the problem? (and if it's the hw problem,
kernel could maybe show it the better way then just crashing).
I'm going to repeat tests with older kernels which were working
OK, and I can also test newer ones. I'll also try to get new
cable of same length to check it again.
Do You have any other ideas what else I should check?
with best regards
nik



On Sun, Jan 24, 2010 at 04:48:53AM -0500, tytso@mit.edu wrote:
> On Sun, Jan 24, 2010 at 08:19:43AM +0100, Nikola Ciprich wrote:
> > Hi,
> > yes, I can reproduce it reliably, I'll give it a try tomorrow and
> > report.
> > have a nice day.
> 
> Thanks, I appreciate it.  If it does reproduce on 2.6.33-rc3+, could
> you send me the output of "dumpe2fs -h /dev/XXX"?
> 
> Best regards,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
