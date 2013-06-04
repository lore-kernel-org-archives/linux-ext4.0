From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/26] jbd2: Remove journal_head from descriptor buffers
Date: Tue, 4 Jun 2013 12:06:53 -0400
Message-ID: <20130604160653.GD25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54725 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3FDQGz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:06:55 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:36AM +0200, Jan Kara wrote:
> Similarly as for metadata buffers, also log descriptor buffers don't
> really need the journal head. So strip it and remove BJ_LogCtl list.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
