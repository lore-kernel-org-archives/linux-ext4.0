From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix undefined bit shift result in
 ext4_fill_flex_info
Date: Mon, 15 Oct 2012 13:00:09 -0400
Message-ID: <20121015170009.GA30787@thunk.org>
References: <1349248307-31225-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55580 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab2JORAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 13:00:13 -0400
Content-Disposition: inline
In-Reply-To: <1349248307-31225-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2012 at 09:11:47AM +0200, Lukas Czerner wrote:
> The result of the bit shift expression in
> '1 << sbi->s_log_groups_per_flex' can be undefined in the case that
> s_log_groups_per_flex is 31 because the result of the shift is bigger
> than INT_MAX. In reality this probably should not cause much problems
> since we'll end up with INT_MIN which will then be converted into
> 'unsigned int' type, but nevertheless according to the ISO C99 the
> result is actually undefined.
> 
> Fix this by changing the left operand to 'unsigned int' type.
> 
> Note that the commit d50f2ab6f050311dbf7b8f5501b25f0bf64a439b already
> tried to fix the undefined behaviour, but this was missed.
> 
> Thanks to Laszlo Ersek for pointing this out and suggesting the fix.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Laszlo Ersek <lersek@redhat.com>

Thanks, applied.

					- Ted
