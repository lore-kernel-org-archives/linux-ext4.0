From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/74] debugfs: fix various minor bogosity
Date: Thu, 12 Dec 2013 12:44:11 -0500
Message-ID: <20131212174411.GI13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011928.30655.5637.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Darren Hart <dvhart@linux.intel.com>, linux-ext4@vger.kernel.org,
	Robert Yang <liezhi.yang@windriver.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39388 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3LLRoR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:44:17 -0500
Content-Disposition: inline
In-Reply-To: <20131211011928.30655.5637.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:19:28PM -0800, Darrick J. Wong wrote:
> We should really use the ext2fs memory allocator functions in
> copy_file(), and we really should return a value if there's allocation
> problems.
> 
> Also fix up a minor bogosity in an error message.

Thanks, applied.

					- Ted
