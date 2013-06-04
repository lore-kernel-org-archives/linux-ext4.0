From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/26] jbd2: Cleanup needed free block estimates when
 starting a transaction
Date: Tue, 4 Jun 2013 12:17:45 -0400
Message-ID: <20130604161745.GG25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54734 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab3FDQRu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:17:50 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:39AM +0200, Jan Kara wrote:
> __jbd2_log_space_left() and jbd_space_needed() were kind of odd.
> jbd_space_needed() accounted also credits needed for currently committing
> transaction while it didn't account for credits needed for control blocks.
> __jbd2_log_space_left() then accounted for control blocks as a fraction of free
> space. Since results of these two functions are always only compared against
> each other, this works correct but is somewhat strange. Move the estimates so
> that jbd_space_needed() returns number of blocks needed for a transaction
> including control blocks and __jbd2_log_space_left() returns free space in the
> journal (with the committing transaction already subtracted). Rename functions
> to jbd2_log_space_left() and jbd2_space_needed() while we are changing them.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
