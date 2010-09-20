From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Don't hold spinlock while calling
 ext4_issue_discard()
Date: Mon, 20 Sep 2010 09:44:23 -0400
Message-ID: <20100920134423.GH3554@thunk.org>
References: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
 <1284144691-15576-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47036 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab0ITNoZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Sep 2010 09:44:25 -0400
Content-Disposition: inline
In-Reply-To: <1284144691-15576-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 10, 2010 at 08:51:31PM +0200, Lukas Czerner wrote:
> We can't hold spinlock because we can get rescheduled.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, added to the ext4 patch queue.  For both patches I adjusted
the patch summary to be a bit more descriptive:

0dc23a4 ext4: don't hold spinlock while calling ext4_issue_discard()
9c54307 ext4: Check for negative error code from sb_issue_discard

It makes it easier to figure out which patches are which when you use
"git log --oneline".

					- Ted
