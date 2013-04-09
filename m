From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V3] ext4: speed-up releasing blocks on commit
Date: Tue, 9 Apr 2013 12:36:48 -0400
Message-ID: <20130409163648.GA5980@thunk.org>
References: <1364498818-17909-1-git-send-email-qrxd43@motorola.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60675 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936464Ab3DIQgv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 12:36:51 -0400
Content-Disposition: inline
In-Reply-To: <1364498818-17909-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 28, 2013 at 11:26:58PM +0400, Andrey Sidorov wrote:
> Improve mb_free_blocks speed by clearing entire range at once instead of
> iterating over each bit. Freeing block-by-block also makes buddy bitmap
> subtree flip twice making most of the work a no-op. Very few bits in buddy
> bitmap require change, e.g. freeing entire group is a 1 bit flip only.
> As a result, releasing blocks of 60G file now takes 5ms instead of 2.7s.
> This is especially good for non-preemptive kernels as there is no
> rescheduling during release.
> 
> Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>

Thanks, added to the dev branch for testing.

					- Ted
