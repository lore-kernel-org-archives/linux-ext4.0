From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: fix hole punch failure when depth is greater
 than 0
Date: Sun, 22 Jul 2012 20:34:40 -0400
Message-ID: <20120723003440.GG9958@thunk.org>
References: <1341937570-5229-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lczerner@redhat.com, Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40590 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2GWAes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2012 20:34:48 -0400
Content-Disposition: inline
In-Reply-To: <1341937570-5229-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 10, 2012 at 09:56:10PM +0530, Ashish Sangwan wrote:
> Whether to continue removing extents or not is decided by the return value
> of function ext4_ext_more_to_rm() which checks 2 conditions:
> a) if there are no more indexes to process.
> b) if the number of entries are decreased in the header of "depth -1".
> 
> In case of hole punch, if the last block to be removed is not part of the
> last extent index than this index will not be deleted, hence the number of
> valid entries in the extent header of "depth - 1" will remain as it is and
> ext4_ext_more_to_rm will return 0 although the required blocks are not
> yet removed.
> 
> This patch fixes the above mentioned problem as instead of removing the
> extents from the end of file, it starts removing the blocks from the
> particular extent from which removing blocks is actually required and
> continue backward until done.
> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Applied, with a cc: to stable@kernel.org since it is a bug fix.

Thanks for submitting this patch!

	      	       			       	  - Ted
