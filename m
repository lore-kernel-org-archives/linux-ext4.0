From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Do no use yield() in ext4 code
Date: Sun, 10 Mar 2013 22:41:07 -0400
Message-ID: <20130311024107.GH10090@thunk.org>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
 <1362730998-3263-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52368 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab3CKClM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Mar 2013 22:41:12 -0400
Content-Disposition: inline
In-Reply-To: <1362730998-3263-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 08, 2013 at 09:23:18AM +0100, Lukas Czerner wrote:
> Using yield() is strongly discouraged (see sched/core.c) especially
> since we can just use cond_resched().
> 
> Replace all use of yield() with cond_resched().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
