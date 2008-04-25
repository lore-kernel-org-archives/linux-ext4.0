From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Fri, 25 Apr 2008 08:47:40 -0700
Message-ID: <20080425084740.cab1cdf8.randy.dunlap@oracle.com>
References: <48118B73.6000700@gmail.com>
	<20080425.004943.148536408.davem@davemloft.net>
	<48118EAB.5040004@gmail.com>
	<20080425.005816.249606540.davem@davemloft.net>
	<48118F85.4060703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	zdenek.kabelac@gmail.com, mingo@elte.hu, rjw@sisk.pl,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
	clameter@sgi.com
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:60989 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761714AbYDYPvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 11:51:41 -0400
In-Reply-To: <48118F85.4060703@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 25 Apr 2008 10:00:05 +0200 Jiri Slaby wrote:

> On 04/25/2008 09:58 AM, David Miller wrote:
> >>> If so that could match up to the pattern.  It is just one theory
> >>> though.  The wireless possibility holds just as much weight.
> >> The mac80211 is theory too so far :).
> > 
> > I'll try to do some commit mining of my own.
> 
> BTW Doesn't exist any tool to compare diffs? Particularly 
> 2.6.28-rc8-mm1..2.6.28-rc8-mm2 with 2.6.25..2.6.25-git2... I would just give it 
> a try.

'interdiff', part of the patchutils package:
http://cyberelk.net/tim/software/patchutils/

---
~Randy
