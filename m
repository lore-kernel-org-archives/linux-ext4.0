From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
Date: Wed, 30 Jan 2013 14:45:35 +0000
Message-ID: <20130130144535.GK4503@ZenIV.linux.org.uk>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49363 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3A3Opi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2013 09:45:38 -0500
Content-Disposition: inline
In-Reply-To: <1359502081-20240-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
> 
>   Hi,
> 
>   since nobody seem to have picked up any of the patches (at least
> nobody told me so), I've added acks I received to the patches and I'm
> sending them to Al for merging. Al, can you please merge these? Thanks.

VFS part (4/4) picked; IMO at least ext* and xfs should go through the
filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
it as well - not sure how active their tree is these days...
