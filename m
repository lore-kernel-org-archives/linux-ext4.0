From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] fix transaction issues for ext4_fallocate and
 ext_zero_range
Date: Mon, 25 Aug 2014 21:30:55 -0400
Message-ID: <20140826013055.GE11317@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48884 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbaHZBa6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 21:30:58 -0400
Content-Disposition: inline
In-Reply-To: <1408707147-22482-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 22, 2014 at 03:32:26PM +0400, Dmitry Monakhov wrote:
> After commit f282ac19d86f we use different transactions for preallocation
> and i_disksize update which result in complain from fsck after power-failure.
> spotted by generic/019. IMHO this is regression because fs becomes inconsistent,
> even more 'e2fsck -p' will no longer works (which drives admins go crazy)
> Same transaction requirement applies ctime,mtime updates
> 
> testcase: xfstest generic/019
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
