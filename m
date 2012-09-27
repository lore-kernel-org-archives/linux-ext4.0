From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused function ext4_ext_check_cache
Date: Wed, 26 Sep 2012 21:08:22 -0400
Message-ID: <20120927010822.GB15707@thunk.org>
References: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52601 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2I0BI1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 21:08:27 -0400
Content-Disposition: inline
In-Reply-To: <1347457961-16182-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 12, 2012 at 09:52:41AM -0400, Lukas Czerner wrote:
> Remove unused function ext4_ext_check_cache() and merge the code back to
> the ext4_ext_in_cache().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks!

					- Ted
