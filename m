From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] e2fsck: update j_tail_sequence after recovery
Date: Tue, 5 Jul 2016 23:11:15 -0400
Message-ID: <20160706031115.GO15193@thunk.org>
References: <1467763839-10311-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Youngjin Gil <youngjin.gil@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46712 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbcGFDLS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jul 2016 23:11:18 -0400
Content-Disposition: inline
In-Reply-To: <1467763839-10311-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2016 at 09:10:39AM +0900, Daeho Jeong wrote:
> When journal is released, s_sequence is set to j_tail_sequence.
> But, currently, even if the recovery process is successfully completed,
> the j_tail_sequence and, finally, s_sequence are never changed. By this,
> when we repeat doing power-off the device suddenly and executing e2fsck
> without full scan before mount, the s_sequence number will never change
> and, in a very rare case, newly generated journal logs will be
> surprisingly grafted to the old journal logs. In this case, out-of-date
> metadata log can be replayed on the filesystem area and the filesystem
> can be crashed unintentionally by journal recovery process. Therefore,
> we need to update j_tail_sequence after recovery process is successfully
> completed in e2fsck.
> 
> Youngjin had repeated this test and found the problem. With our test,
> the filesystem crash occurred within 4 hours.
> 
> Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>

Applied, thanks.

						 - Ted
