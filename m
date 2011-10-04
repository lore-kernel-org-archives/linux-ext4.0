From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkfs'ing a 48-bit fs... or not.
Date: Mon, 03 Oct 2011 23:03:40 -0500
Message-ID: <4E8A859C.2070501@redhat.com>
References: <4E8A2F3F.30700@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1JDEDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 00:03:43 -0400
In-Reply-To: <4E8A2F3F.30700@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/3/11 4:55 PM, Eric Sandeen wrote:
> Has anyone tried mke2fs at its limits?  The latest git tree seems to fail in several ways.
> (Richard Jones reported the initial failure)
> 
> # truncate --size 1152921504606846976 reallybigfile 
> # mke2fs -t ext4 reallybigfile

...

> Trying it with "-O bigalloc" (which should be automatic at this size,
> I think?) just goes away for a very long time, I'm not sure what it's
> thinking about, or if it's in a loop somewhere (looking now).

It comes up with too many inodes, then tries to reduce the count,
but the "waste not want not" logic bumps it back up... ipg eventually
goes "below" 0 but it's unsigned so it goes on in this loop forever.

Some of this is my fault... I put that retry logic in years ago.  :(

I'll see what I can do to fix it up.

-Eric
