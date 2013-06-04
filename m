From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/26] ext4: Split extent conversion lists to reserved &
 unreserved parts
Date: Tue, 4 Jun 2013 14:22:02 -0400
Message-ID: <20130604182202.GI3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-19-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54800 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3FDSWG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:22:06 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-19-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:51AM +0200, Jan Kara wrote:
> Now that we have extent conversions with reserved transaction, we have
> to prevent extent conversions without reserved transaction (from DIO
> code) to block these (as that would effectively void any transaction
> reservation we did). So split lists, work items, and work queues to
> reserved and unreserved parts.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
