From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Update documentation to correct the
 inode_readahead_blks option name
Date: Thu, 24 Dec 2009 17:52:22 -0500
Message-ID: <20091224225222.GN21594@thunk.org>
References: <1261035623-28474-1-git-send-email-antonf@turbolinux.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Fang Wenqi <antonf@turbolinux.com.cn>
To: Fang Wenqi <anton.fang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33216 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZLXWwd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Dec 2009 17:52:33 -0500
Content-Disposition: inline
In-Reply-To: <1261035623-28474-1-git-send-email-antonf@turbolinux.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 17, 2009 at 03:40:23PM +0800, Fang Wenqi wrote:
> Per commit 240799cd, the option name for readahead should be
> inode_readahead_blks, not inode_readahead.
> 
> Signed-off-by: Fang Wenqi <antonf@turbolinux.com.cn>

Thanks, added to the ext4 patch queue.

						- Ted
