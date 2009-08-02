From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Sun, 2 Aug 2009 13:35:48 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908021331350.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de> <alpine.DEB.2.01.0908021314030.5831@bogon.housecafe.de> <200908022226.52228.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Rientjes <rientjes@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZHBUft (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Aug 2009 16:35:49 -0400
In-Reply-To: <200908022226.52228.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Rafael,

On Sun, 2 Aug 2009 at 22:26, Rafael J. Wysocki wrote:
> The patches supposed to fix this issue went in right before -rc5 AFAIC.

Sorry, you fell off my Cc list, thanks for catching this. I've seen these 
patches too, but David confirmed:

---------------------------------------------------------------------
> Is this related to the WARNING in #13666?
> I'm pretty sure the kernel already includes the patches you
> mentioned, "git show" said "b592972493c38665efd7d429a01b23fcb21e331a".
> Also, I just pulled again and mm/ was not touched any more.

Your kernel includes the fixes for the __alloc_pages_nodemask() warning
that was reported in http://bugzilla.kernel.org/show_bug.cgi?id=13666. 
---------------------------------------------------------------------

So, it looks like it's not related to #13666.

> Can you try to reproduce with -rc5?

Yes, I'm building it right now (actually, I'm using current -git tree), 
will report back.


Thanks,
Christian.
-- 
BOFH excuse #6:

global warming
