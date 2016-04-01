From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Retry block allocation for failed DIO and DAX
 writes
Date: Fri, 1 Apr 2016 02:06:35 -0400
Message-ID: <20160401060635.GB29897@thunk.org>
References: <1458565946-27627-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbcDAGGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Apr 2016 02:06:39 -0400
Content-Disposition: inline
In-Reply-To: <1458565946-27627-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2016 at 02:12:26PM +0100, Jan Kara wrote:
> Currently if block allocation for DIO or DAX write fails due to ENOSPC,
> we just returned it to userspace. However these ENOSPC errors can be
> transient because the transaction freeing blocks has not yet committed.
> This demonstrates as failures of generic/102 test when the filesystem is
> mounted with 'dax' mount option.
> 
> Fix the problem by properly retrying the allocation in case of ENOSPC
> error in get blocks functions used for direct IO.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
