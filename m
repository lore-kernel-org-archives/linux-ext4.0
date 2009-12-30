From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for v2.6.33
Date: Wed, 30 Dec 2009 12:51:11 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912301249520.11961@localhost.localdomain>
References: <E1NOdOL-0001s1-4J@closure.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZL3UvP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2009 15:51:15 -0500
In-Reply-To: <E1NOdOL-0001s1-4J@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 26 Dec 2009, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab the following bug fixes for v2.6.33.

I don't get the diffstat you claim, so I'm unpulling. I've got a lot of 
extra work in fs/ext4/inode.c, and fewer lines in fs/ext4/extents.c, for a 
total of

  15 files changed, 189 insertions(+), 94 deletions(-)

instead of you claimed

>  15 files changed, 108 insertions(+), 24 deletions(-)

Hmm?

		Linus
