From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix lazyinit hang after removing request
Date: Tue, 2 Nov 2010 14:20:23 -0400
Message-ID: <20101102182023.GD25614@thunk.org>
References: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40952 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0KBSU2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Nov 2010 14:20:28 -0400
Content-Disposition: inline
In-Reply-To: <1288358420-11643-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 29, 2010 at 03:20:20PM +0200, Lukas Czerner wrote:
> When the request has been removed from the list and no other request
> has been issued, we will end up with next wakeup scheduled to
> MAX_JIFFY_OFFSET which is bad. So check for that.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Queued for pushing to Linus for 2.6.27-rc2, thanks.

							- Ted
