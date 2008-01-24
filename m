From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Thu, 24 Jan 2008 18:32:15 +0100
Message-ID: <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andreas Dilger <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vge
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:59460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYAXRc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2008 12:32:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> I'd tried to advocate SIGDANGER some years ago as well, but none of
>> the kernel maintainers were interested.  It definitely makes sense
>> to have some sort of mechanism like this.  At the time I first brought
>> it up it was in conjunction with Netscape using too much cache on some
>> system, but it would be just as useful for all kinds of other memory-
>> hungry applications.
> 
> There is an early thread for a /proc file which you can add to your
> poll() set and it will wake people when memory is low. Very elegant and
> if async support is added it will also give you the signal variant for
> free.

IMO you'll need a userspace daemon. The kernel does only know about the
amount of memory available / recommended for a system (or container),
while the user knows which program's cache is most precious today.

(Off cause the userspace daemon will in turn need the /proc file.)

I think a single, system-wide signal is the second-to worst solution: All
applications (or the wrong one, if you select one) would free their caches
and start to crawl, and either stay in this state or slowly increase their
caches again until they get signaled again. And the signal would either
come too early or too late. The userspace daemon could collect the weighted
demand of memory from all applications and tell them how much to use.
