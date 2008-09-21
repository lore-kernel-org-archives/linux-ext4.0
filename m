From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ext4: Don't use 'struct dentry' for internal lookups
Date: Sun, 21 Sep 2008 12:48:01 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0809211241330.4475@nehalem.linux-foundation.org>
References: <E1KhEil-0004s7-Ve@closure.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbYIUTs0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2008 15:48:26 -0400
In-Reply-To: <E1KhEil-0004s7-Ve@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 20 Sep 2008, Theodore Ts'o wrote:
> 
> Linus, I plan to push this to you at the next patch window; I'm just
> cc'ing you now since you authored the original patch.
> 
> It seems that the ext3 version of the patch seems not to have been
> picked up by akpm.  Want me to resend it to him?

That would be good. I guess we don't have any ext3 maintainer. But I also 
wouldn't object to just getting it through you if you want to.

> Also, per your complaints about the stack-heavy ext3 users, one fairly
> easy fix for x86_64 (the stack usage isn't all that bad on x86 when
> pointers are only 32-bits) is pretty much all of the places where we use
> "unsigned long" in fs/ext3 should be safely replaceable by "unsigned
> int" or "u32".  Sigh...

Somebody who knows the code should check it out, but yes.. I just checked 
that at least some versions of gcc will do the right thing, and only spill 
in 32 bits (I was worried that maybe gcc would end up spilling the whole 
64-bit register anyway).

				Linus
