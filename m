From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v2 1/2] mbcache: decoupling the locking of local from
 global data
Date: Thu, 22 Aug 2013 15:33:32 +0000
Message-ID: <52162F4C.3090205@hp.com>
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1377186876-57291-1-git-send-email-tmac@hp.com> <1377186876-57291-2-git-send-email-tmac@hp.com> <CA+55aFze8ZC0YP+TdwDFRPpa=BqUhY25RhEJb6c9pkCk2CZfVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4687 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab3HVVfk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Aug 2013 17:35:40 -0400
In-Reply-To: <CA+55aFze8ZC0YP+TdwDFRPpa=BqUhY25RhEJb6c9pkCk2CZfVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the comments.

On 08/22/2013 04:53 PM, Linus Torvalds wrote:
> 
> Please don't do these ugly and pointless preprocessor macro expanders
> that hide what the actual operation is.
> 
> The DEBUG case seems to be just for your own testing anyway, so even
> that shouldn't exist in the merged version.
> 

Sorry, will clean them all up.

> 
> And this is really ugly. Again it's also then hidden behind the ugly macro.
> 
> First off, the thousand-time retry seems completely excessive. Does it
> actually need any retry AT ALL? If the hash entry changes, either you
> should retry forever, or if you feel that can result in livelocks
> (fair enough) and you need a fallback case to a bigger lock, then why
> not just do the fallback immediately?
> 
> More importantly, regardless of that retry issue, this seems to be
> abstracted at the wrong level, resulting in every single user of this
> repeating the same complex and hard-to-understand incantation:
> 

Looks like this is a misjudgement on my part.  There is really no need to guard against mb_cache_entry from moving to a different hash chain, as the shrinking and allocation function already protecting against each other thorugh mb_cache_spinlock.  The retry is not needed.

> 
> where the only difference is that the last one doesn't unlock
> afterwards because it runs in a loop with that LRU list lock held.
> Ugh.

Followed the above logic, all these pieces of code are also not necessary and could be just a simple unhash, as the original.

> 
> The locking logic also isn't explained anywhere, making the
> hard-to-read code even harder to read.


Will add comment, explaining the locking logic.

> 
>              Linus
> 

Thanks,
Mak.

