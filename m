From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/26] jbd2: Don't create journal_head for temporary
 journal buffers
Date: Tue, 4 Jun 2013 12:04:41 -0400
Message-ID: <20130604160441.GC25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54721 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab3FDQEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:04:44 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:35AM +0200, Jan Kara wrote:
> When writing metadata to the journal, we create temporary buffer heads
> for that task. We also attach journal heads to these buffer heads but
> the only purpose of the journal heads is to keep buffers linked in
> transaction's BJ_IO list. We remove the need for journal heads by
> reusing buffer_head's b_assoc_buffers list for that purpose. Also since
> BJ_IO list is just a temporary list for transaction commit, we use a
> private list in jbd2_journal_commit_transaction() for that thus removing
> BJ_IO list from transaction completely.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
