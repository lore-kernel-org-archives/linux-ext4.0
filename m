From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: optimize jbd2_journal_force_commit V3
Date: Wed, 12 Jun 2013 20:42:24 -0400
Message-ID: <20130613004224.GA14627@thunk.org>
References: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57438 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab3FMAm3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 20:42:29 -0400
Content-Disposition: inline
In-Reply-To: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:40:59PM +0400, Dmitry Monakhov wrote:
> Current implementation of jbd2_journal_force_commit() is suboptimal because
> result in empty and useless commits. But callers just want to force and wait
> any unfinished commits. We already has jbd2_journal_force_commit_nested()
> which does exactly what we want, except we are guaranteed that we do not hold
> journal transaction open.
> 
> Changes since V3 to V2
>  - API changes according to Jan's comments
>  - make __jbd2_journal_force_commit() static
> 
> Changes since V2 to V1
>  - Fix incorrect return value  according to Jan's comments.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

						- Ted
