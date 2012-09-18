From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Make orphan functions no-op in no-journal mode
Date: Tue, 18 Sep 2012 13:48:47 -0400
Message-ID: <20120918174847.GA28689@thunk.org>
References: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
 <1347983585-22940-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51341 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2IRRsv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 13:48:51 -0400
Content-Disposition: inline
In-Reply-To: <1347983585-22940-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 08:53:05AM -0700, Anatol Pomozov wrote:
> Instead of checking whether the handle is valid, we check if journal is
> enabled. This avoids using shared mutext usage in all cases when
> ext4_orphan_del(NULL,..) is called in no-journal mode (i.e. in error
> path).
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>

Thanks, applied.

						- Ted
