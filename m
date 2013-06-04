From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 25/26] ext4: Don't wait for extent conversion in
 ext4_punch_hole()
Date: Tue, 4 Jun 2013 14:46:36 -0400
Message-ID: <20130604184636.GP3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-26-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54830 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3FDSqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:46:37 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-26-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:58AM +0200, Jan Kara wrote:
> We don't have to wait for extent conversion in ext4_punch_hole() as
> buffered IO for the punched range has been flushed and waited upon (thus
> all extent conversions for that range have completed). Also we wait for
> all DIO to finish using inode_dio_wait() so there cannot be any extent
> conversions pending due to direct IO.
> 
> Also remove ext4_flush_unwritten_io() since it's unused now.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
