From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix reservation release on invalidatepage for
 delalloc fs
Date: Fri, 3 Jul 2015 21:17:34 -0400
Message-ID: <20150704011734.GN9456@thunk.org>
References: <1433406301-29136-1-git-send-email-lczerner@redhat.com>
 <20150608151651.GD19168@thunk.org>
 <alpine.LFD.2.00.1506081729390.1273@localhost.localdomain>
 <alpine.LFD.2.00.1506190953120.14650@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39450 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbbGDBRh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jul 2015 21:17:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1506190953120.14650@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for not getting back to this patch earlier.  When I took another
look at it, I realized I misunderstood what was going on.  The patch
looks correct, and I've added it to the ext4.git tree as part of bug
fixes that I'll send out to Linus for 4.2.

Thanks,

						- Ted
