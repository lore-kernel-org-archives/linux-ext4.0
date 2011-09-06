From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v7] ext4: fix 1k block bugs
Date: Tue, 6 Sep 2011 00:59:42 -0400
Message-ID: <20110906045942.GA4059@thunk.org>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59837 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1IFE7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 00:59:47 -0400
Content-Disposition: inline
In-Reply-To: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allison,

Many, many thanks for your work on this patch series!!  It's clearly
been a very long slog.

I've pulled in the first three patches, since I think those are
clearly correct at this point.  One minor change I've made was I fixed
the spelling the flag, which I channged to
EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED.  (Sorry, but seeing MAPED
everywhere was just grating on my nerves.  :-)

I didn't want to apply your 4th patch in the series since we're
planning on reducing the usage of i_mutex in the fs/ext4 code proper,
as recommended by Christoph.  It wasn't immediately obvious to me
whether it was safe to apply any of the patches after #4, so for now
I've just merged in the first three, since they clearly fix real
problems that show up in xfstests.

Can you comment on whether patches #5, #6, and #7 depend on #4?

Thanks,

						- Ted
