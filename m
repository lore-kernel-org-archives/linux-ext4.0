From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: Avoid issuing barriers on error recovery path
Date: Sun, 15 Nov 2009 19:47:57 -0500
Message-ID: <20091116004757.GN4323@mit.edu>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <1256647729-29834-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41722 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZKPAsi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 19:48:38 -0500
Content-Disposition: inline
In-Reply-To: <1256647729-29834-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 27, 2009 at 01:48:47PM +0100, Jan Kara wrote:
> There is no reason why we should issue IO barriers when we
> just hit an error in ext4_sync_file. So move out: label to
> just return and introduce flush: label to those places which
> really need it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Once the out: label is moved to just before the "return ret;", it's
actually cleaner to simply replace all of the "goto out" with "return
ret;" statements.....

						- Ted
