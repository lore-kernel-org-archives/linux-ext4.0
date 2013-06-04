From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/26] jbd2: Fix race in t_outstanding_credits update in
 jbd2_journal_extend()
Date: Tue, 4 Jun 2013 12:23:24 -0400
Message-ID: <20130604162324.GH25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54737 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab3FDQX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:23:26 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-8-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:40AM +0200, Jan Kara wrote:
> jbd2_journal_extend() first checked whether transaction can accept extending
> handle with more credits and then added credits to t_outstanding_credits.
> This can race with start_this_handle() adding another handle to a transaction
> and thus overbooking a transaction. Make jbd2_journal_extend() use
> atomic_add_return() to close the race.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
