From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use s_extent_max_zeroout_kb value as number of kb
Date: Tue, 12 Mar 2013 12:45:11 -0400
Message-ID: <20130312164511.GC4959@thunk.org>
References: <1363106209-1883-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52892 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3CLQpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 12:45:16 -0400
Content-Disposition: inline
In-Reply-To: <1363106209-1883-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

I'm on the fence about whether to submit this after -rc2 or not.
This appears to make potential bug much rarer, and it's a trivial
patch to backport, but it does make rather large changes in how we
handle fragmented filesystem.  (For the better, but it's a large
change, and it is getting rather late in the season.)

I'm going to include in the dev branch for now, and give it all a good
instensive testing, but there may be some patches in dev that may get
deferred to the next merge window before I send a pull request to
Linus (probably during the coming weekend).

Folks should feel free to propose patches they think should wait for
the next merge window.

					- Ted
