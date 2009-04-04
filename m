From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sat, 4 Apr 2009 15:19:19 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904041513290.4023@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu>
 <alpine.LFD.2.00.0904041448090.4023@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbZDDWWE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 18:22:04 -0400
In-Reply-To: <alpine.LFD.2.00.0904041448090.4023@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 4 Apr 2009, Linus Torvalds wrote:
> 
> Hmm. I can certainly see a very noticeable improvement.

.. and btw, just to put that into perspective - I ended up running with 
that repeated 'dd+sync+rm' in the background for quite a while, and the 
machine was in no way unusable. I don't think I saw a single "ooh, that 
feels really dead" case with anticipatory, although I saw several "bad 
stutter" cases.

Of course, with the whole "overwrite" case, things are really much 
smoother, and I can hardly notice anything happening at all. Although I 
_do_ get an occasional 200-600ms fsync hickup, and I can tell those very 
clearly. But if that was the worst I'd ever see, I'd be a very happy 
person. It's a good goal to have, I suspect.

		Linus
