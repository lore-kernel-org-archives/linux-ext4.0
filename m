From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/26] ext4: Use generic_file_fsync() in
 ext4_file_fsync() in nojournal mode
Date: Tue, 4 Jun 2013 14:38:15 -0400
Message-ID: <20130604183815.GM3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-23-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54819 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3FDSiS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:38:18 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-23-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:55AM +0200, Jan Kara wrote:
> Just use the generic function instead of duplicating it. We only need
> to reshuffle the read-only check a bit (which is there to prevent
> writing to a filesystem which has been remounted read-only after error
> I assume).
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

				- Ted
