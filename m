From: Bob Copeland <me@bobcopeland.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Fri, 21 Aug 2009 08:36:57 -0400
Message-ID: <20090821123657.GA27001@hash.localnet>
References: <20090820015624.GE524@hash.localnet> <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com> <20090820111937.GF524@hash.localnet> <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com> <20090821020633.GA25571@hash.localnet> <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Paris <eparis@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4412 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZHUMiq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 08:38:46 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 21, 2009 at 08:46:37AM +0200, Vegard Nossum wrote:
> 2009/8/21 Bob Copeland <me@bobcopeland.com>:
> > WARNING: kmemcheck: Caught 32-bit read from freed memory (f34a443c)
> > eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee008a06f700011000
> >  a a a a a a a a a a a a a a a a a a a a a a a a f f f f f f f f
> >
> > I think that is list_empty() here where %eax is list_head
> > and event_list->next is the read location... which definitely
> > doesn't look like a pointer, if I'm reading it correctly.
> 
> I think f34a443c is a valid pointer. On my machine, at least:

I meant list->next, which was 00100100 here.  (By the way, my first
time using kmemcheck, very nice tool!)

[race condition explanation snipped]

> I think that's it. Any thoughts? I put Eric Paris on Cc.

Thanks!  With a fresh pull containing the fsnotify fix the kmemcheck
warning is gone.  So unless I see anything else I'll assume that this
one is already fixed, sorry for the false alarm.

-- 
Bob Copeland %% www.bobcopeland.com

