From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Recalculate journal credits as inode depth
 changes
Date: Mon, 15 Jun 2015 00:22:56 -0400
Message-ID: <20150615042256.GG15793@thunk.org>
References: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35203 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbbFOEW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 00:22:57 -0400
Content-Disposition: inline
In-Reply-To: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 09, 2015 at 08:58:45AM +0200, Lukas Czerner wrote:
> Currently in ext4_alloc_file_blocks() the number of credits is
> calculated only once before we enter the allocation loop. However within
> the allocation loop the extent tree depth can change, hence the number
> of credits needed can increase potentially exceeding the number of credits
> reserved in the handle which can cause journal failures.
> 
> Fix this by recalculating number of credits when the inode depth
> changes. Note that even though ext4_alloc_file_blocks() is only
> currently used by extent base inodes we will avoid recalculating number
> of credits unnecessarily in the case of indirect based inodes.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
