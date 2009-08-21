From: Bob Copeland <me@bobcopeland.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Thu, 20 Aug 2009 22:06:33 -0400
Message-ID: <20090821020633.GA25571@hash.localnet>
References: <20090820015624.GE524@hash.localnet> <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com> <20090820111937.GF524@hash.localnet> <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2294 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZHUCHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 22:07:13 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 02:02:49PM +0200, Vegard Nossum wrote:
> > I'll try that and kmemcheck next.
> 
> Hm, I'm afraid kmemcheck gives some known false positives related to
> bitfields in ext4 code, so in the case that something turned up, it
> might be hard to distinguish it from those false positives.

Well I didn't get anything from ext4 so far.  I did hit one with
fsnotify:

WARNING: kmemcheck: Caught 32-bit read from freed memory (f34a443c)
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee008a06f700011000
 a a a a a a a a a a a a a a a a a a a a a a a a f f f f f f f f
                                                         ^

Pid: 2745, comm: fsck.ext4 Not tainted (2.6.31-rc6 #2) MacBook1,1
EIP: 0060:[<c10f3656>] EFLAGS: 00010217 CPU: 0
EIP is at inotify_handle_event+0x76/0xc0
EAX: f34a443c EBX: f34a4438 ECX: 00000000 EDX: f6732000
ESI: f6559764 EDI: 00000000 EBP: f6733f0c ESP: c1527450
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: f6c046d4 CR3: 367fb000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c10f0d78>] fsnotify+0xa8/0x130
 [<c10c5e11>] __fput+0xb1/0x1e0
 [<c10c5f55>] fput+0x15/0x20
 [<c10c2ca7>] filp_close+0x47/0x80
 [<c10c2d54>] sys_close+0x74/0xc0
 [<c1002ec8>] sysenter_do_call+0x12/0x36
 [<ffffffff>] 0xffffffff

I think that is list_empty() here where %eax is list_head
and event_list->next is the read location... which definitely
doesn't look like a pointer, if I'm reading it correctly.

inotify_fsnotify.o:

        /* did event_priv get attached? */
        if (list_empty(&fsn_event_priv->event_list))
 143:   8d 43 04                lea    0x4(%ebx),%eax

        event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
        if (unlikely(!event_priv))
                return -ENOMEM;

        fsn_event_priv = &event_priv->fsnotify_event_priv_data;
 146:   39 43 04                cmp    %eax,0x4(%ebx)     <=== read here
 149:   74 1d                   je     168 <inotify_handle_event+0x98>

-- 
Bob Copeland %% www.bobcopeland.com

