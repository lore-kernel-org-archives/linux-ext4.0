From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/26] ext4: Stop messing with nr_to_write in
 ext4_da_writepages()
Date: Tue, 4 Jun 2013 12:49:43 -0400
Message-ID: <20130604164943.GB3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-12-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54757 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3FDQts (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:49:48 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-12-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:44AM +0200, Jan Kara wrote:
> Writeback code got better in how it submits IO and now the number of
> pages requested to be written is usually higher than original 1024. The
> number is now dynamically computed based on observed throughput and is
> set to be about 0.5 s worth of writeback. E.g. on ordinary SATA drive
> this ends up somewhere around 10000 as my testing shows. So remove the
> unnecessary smarts from ext4_da_writepages().
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
