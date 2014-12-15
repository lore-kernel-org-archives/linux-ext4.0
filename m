From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: badblocks: Limit maximum number of bad blocks
Date: Sun, 14 Dec 2014 20:55:57 -0500
Message-ID: <20141215015557.GA19946@thunk.org>
References: <1410429804-26459-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55814 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaLOB6H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2014 20:58:07 -0500
Content-Disposition: inline
In-Reply-To: <1410429804-26459-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:03:24PM +0200, Jan Kara wrote:
> Currently maximum number of bad blocks is not limited in any way.
> However our code can really handle at most INT_MAX/2 bad blocks (for
> larger numbers binary search indexes start overflowing). So report
> number of bad blocks is just too big instead of plain segfaulting.
> 
> It won't be too hard to raise the limit but I don't think there's any
> real use for disks with over 1 billion of bad blocks...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
