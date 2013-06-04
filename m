From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/26] ext4: Use transaction reservation for extent
 conversion in ext4_end_io
Date: Tue, 4 Jun 2013 13:29:22 -0400
Message-ID: <20130604172922.GH3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-18-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54788 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab3FDR30 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 13:29:26 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-18-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:50AM +0200, Jan Kara wrote:
> Later we would like to clear PageWriteback bit only after extent conversion
> from unwritten to written extents is performed. However it is not possible
> to start a transaction after PageWriteback is set because that violates
> lock ordering (and is easy to deadlock). So we have to reserve a transaction
> before locking pages and sending them for IO and later we use the transaction
> for extent conversion from ext4_end_io().
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
