From: Ted Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Mon, 4 Apr 2011 13:25:16 -0400
Message-ID: <20110404172516.GA2832@thunk.org>
References: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com>
 <20110331164319.GG21524@quack.suse.cz>
 <alpine.LFD.2.00.1103312255270.3020@dhcp-27-109.brq.redhat.com>
 <20110331222306.GI21524@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34320 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1DDRZT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 13:25:19 -0400
Content-Disposition: inline
In-Reply-To: <20110331222306.GI21524@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 01, 2011 at 12:23:06AM +0200, Jan Kara wrote:
> > Ted, could you pick this up ASAP ? Also I think this needs to go into
> > stable as well.
>   I'll merge it from my tree next week, OK? I don't think there's so much
> hurry as the bug has been there for years and you're the first one to
> report it :).

Agreed, your first patch was quota specific and I'd much rather have
it go through the quota tree.

> BTW, I've also created the patch below which can slightly improve
> performance of quotas on ext4. The modification of the inode was
> unnecessary as well... Ted, can you merge this patch? It's independent from
> the previous one.

Yup, I've added to the ext4 patch queue.

						- Ted
