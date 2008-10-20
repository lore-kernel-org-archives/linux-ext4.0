From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 146/148] fs/Kconfig: move ext2, ext3, ext4, JBD, JBD2
 out
Date: Mon, 20 Oct 2008 11:26:12 -0700
Message-ID: <20081020112612.899384eb.akpm@linux-foundation.org>
References: <200810190328.m9J3Snvw000579@imap1.linux-foundation.org>
	<alpine.LFD.2.00.0810200847310.8651@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: adobriyan@gmail.com, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYJTS0n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Oct 2008 14:26:43 -0400
In-Reply-To: <alpine.LFD.2.00.0810200847310.8651@nehalem.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Oct 2008 08:49:47 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 18 Oct 2008, akpm@linux-foundation.org wrote:
> > 
> > Use fs/*/Kconfig more, which is good because everything related to one
> > filesystem is in one place and fs/Kconfig is quite fat.
> 
> Umm.
> 
> This removes the EXT2 things from fs/Kconfig, but leaves everything else. 
> So now EXT3/EXT4 and JDB/JDB2 symbols are done twice! Well, JDB/JDB2 
> aren't actually wired up, because there's no "source fs/jdb[2]/Kconfig 
> added.
> 
> Whaa?

Thanks for spotting that.  Presumably it's the result of poor me trying
to maintain a large Kconfig shuffle for six weeks while the million mad
monkeys are plinking away changing stuff.

I just shouldn't merge things like this in mid-rc - they're not worth
the effort and risk.  I sometimes tell people "go away and come back in
very late -rc".  I'll do that more often.
