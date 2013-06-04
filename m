From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/26] jbd2: Remove unused waitqueues
Date: Tue, 4 Jun 2013 12:24:42 -0400
Message-ID: <20130604162441.GI25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54740 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab3FDQYo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:24:44 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-9-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:41AM +0200, Jan Kara wrote:
> j_wait_logspace and j_wait_checkpoint are unused. Remove them.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
