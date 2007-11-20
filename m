From: "Christian Kujau" <lists@nerdbynature.de>
Subject: Re: e2fsprogs-interim scm tree?
Date: Tue, 20 Nov 2007 11:24:03 +0100 (CET)
Message-ID: <14319.62.180.231.196.1195554243.squirrel@housecafe.dyndns.org>
References: <alpine.DEB.0.99999.0711200128130.7426@sheep.housecafe.de>
    <20071120031127.GB13125@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:38121 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbXKTKYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2007 05:24:07 -0500
In-Reply-To: <20071120031127.GB13125@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, November 20, 2007 04:11, Theodore Tso wrote:
> There is a git tree.  It's at:
> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary
>
> The bleeding edge branch is the 'pu' (proposed updates), which you
> need if you want the full ext4 features.

Ah, I've seen the git tree, but missed on the 'pu' branch. So it's

# git-checkout -b pu

to get the pu branch?

> Note that the userspace code still needs a lot of work.
> It's for this reason that I haven't been recommending people use it for
> production systems just yet.

Understood. But the more ppl testing your stuff the better, right?

Thanks for your time,
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay
