From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/26] ext4: Remove wait for unwritten extents in
 ext4_ind_direct_IO()
Date: Tue, 4 Jun 2013 14:42:28 -0400
Message-ID: <20130604184228.GO3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-25-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54825 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FDSma (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 14:42:30 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-25-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:57AM +0200, Jan Kara wrote:
> We don't have to wait for unwritten extent conversion in
> ext4_ind_direct_IO() as all writes that happened before DIO are flushed
> by the generic code and extent conversion has happened before we cleared
> PageWriteback bit.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
