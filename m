From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfs: Fix possible use-after-free with AIO
Date: Tue, 29 Jan 2013 18:56:56 -0600
Message-ID: <20130130005656.GM27055@sgi.com>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
 <1359502081-20240-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:42140 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3A3A5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 19:57:01 -0500
Content-Disposition: inline
In-Reply-To: <1359502081-20240-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On Wed, Jan 30, 2013 at 12:27:59AM +0100, Jan Kara wrote:
> Running AIO is pinning inode in memory using file reference. Once AIO
> is completed using aio_complete(), file reference is put and inode can
> be freed from memory. So we have to be sure that calling aio_complete()
> is the last thing we do with the inode.
> 
> CC: xfs@oss.sgi.com
> CC: Ben Myers <bpm@sgi.com>
> CC: stable@vger.kernel.org
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

We picked this up in the xfs tree.  Sorry to keep you hanging.

Regards,
	Ben
