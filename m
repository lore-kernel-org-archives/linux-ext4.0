From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/26] ext4: Improve writepage credit estimate for files
 with indirect blocks
Date: Tue, 4 Jun 2013 12:57:50 -0400
Message-ID: <20130604165750.GD3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-14-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54765 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab3FDQ5x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:53 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-14-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:46AM +0200, Jan Kara wrote:
> ext4_ind_trans_blocks() wrongly used 'chunk' argument to decide whether
> blocks mapped are logically continguous. That is wrong since the argument
> informs whether the blocks are physically continguous. As the blocks
> mapped are always logically continguous and that's all
> ext4_ind_trans_blocks() cares about, just remove the 'chunk' argument.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied with the spelling fix that Darrick pointed out.

	     	 	      	   	   - Ted
