From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Use negative error code
Date: Mon, 20 Sep 2010 09:34:22 -0400
Message-ID: <20100920133422.GG3554@thunk.org>
References: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58416 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab0ITNeY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Sep 2010 09:34:24 -0400
Content-Disposition: inline
In-Reply-To: <1284144691-15576-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 10, 2010 at 08:51:30PM +0200, Lukas Czerner wrote:
> sb_issue_discard() is returning negative error code, so check for
> -EOPNOTSUPP.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
