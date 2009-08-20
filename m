From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Thu, 20 Aug 2009 14:02:49 +0200
Message-ID: <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
References: <20090820015624.GE524@hash.localnet>
	 <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
	 <20090820111937.GF524@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Bob Copeland <me@bobcopeland.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62371 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZHTMCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 08:02:49 -0400
In-Reply-To: <20090820111937.GF524@hash.localnet>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/8/20 Bob Copeland <me@bobcopeland.com>:
> On Thu, Aug 20, 2009 at 08:08:16AM +0300, Pekka Enberg wrote:
>> Someone is stomping on SLAB internal data structures. Ext4 appears i=
n
>> both stack traces so I guess we should CC linux-ext4. How easy is it
>> to reproduce this bug? One option is to try kmemcheck to see if it
>> catches the problem (see Documentation/kmemcheck.txt for details).
>
> I don't yet have a way to reproduce at will but I've anecdotally hit
> this or some related bug 3 times in the last week or two without tryi=
ng,
> I only now captured a stack trace. =C2=A0I can try some workload to e=
xercise
> the filesystem a bit more to see what turns up.
>
> I'll try that and kmemcheck next.

Hm, I'm afraid kmemcheck gives some known false positives related to
bitfields in ext4 code, so in the case that something turned up, it
might be hard to distinguish it from those false positives.

Sorry :-/


Vegard
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
