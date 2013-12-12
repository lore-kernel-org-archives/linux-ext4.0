From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/74] debugfs: fix init_filesys help text
Date: Thu, 12 Dec 2013 12:37:05 -0500
Message-ID: <20131212173705.GF13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011850.30655.33307.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39376 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3LLRhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:37:08 -0500
Content-Disposition: inline
In-Reply-To: <20131211011850.30655.33307.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:18:50PM -0800, Darrick J. Wong wrote:
> The help text for debugfs' init_filesys command is incorrect; the
> second parameter is the size of the filesystem in blocks, not the size
> of an individual filesystem block.  There is in fact no way to set
> that parameter.
> 
> Reported-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
