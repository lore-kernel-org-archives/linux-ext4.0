From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bugfixes/cleanups
Date: Sun, 3 Aug 2008 10:52:42 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0808031050450.3668@nehalem.linux-foundation.org>
References: <E1KPShM-0007Ks-M0@closure.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYHCRxG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Aug 2008 13:53:06 -0400
In-Reply-To: <E1KPShM-0007Ks-M0@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 2 Aug 2008, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Could you please include the expected diffstat too?

I can match up the shortlog to the expected thing, and see that I got what 
you intended for me, but the thing I actually _care_ much more deeply 
about is that it only touched ext4 (and jbd2) in this case. So I like 
matching up the diffstat, with the shortlog being just secondary.

			Linus
