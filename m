From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 14:15:22 +0200
Message-ID: <c4e36d110804250515u713775bdjbb7bfac2d0e83d96@mail.gmail.com>
References: <4811090A.9030809@gmail.com>
	 <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
	 <4812108D.6020103@gmail.com>
	 <20080425.021301.193689806.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jirislaby@gmail.com, torvalds@linux-foundation.org, mingo@elte.hu,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: "David Miller" <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:33683 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbYDYMPZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 08:15:25 -0400
Received: by py-out-1112.google.com with SMTP id u52so5713627pyb.10
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 05:15:23 -0700 (PDT)
In-Reply-To: <20080425.021301.193689806.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/4/25, David Miller <davem@davemloft.net>:
> From: Jiri Slaby <jirislaby@gmail.com>
>
> Date: Fri, 25 Apr 2008 19:10:37 +0200
>
>
>  > I'm going to bisect it, will be back in few hours ;).
>
>
> Thanks for all of this hard work and investigation Jiri!
>

Well just to show it's not happing only to Jiri:

It's actually shows immediately on my box after suspend-resume...

 ./testf     (Jiri's test code from this thread)
alloced 0
WHAT THE HELL (015130f8):
ff00aa00deadcc22 ff00aa00f0adcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
