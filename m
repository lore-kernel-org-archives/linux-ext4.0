From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 01/22] libext2fs: add INLINE_DATA into
 EXT2_LIB_SOFTSUPP_INCOMPAT
Date: Sat, 12 Oct 2013 23:21:17 -0400
Message-ID: <20131013032117.GB22642@thunk.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45335 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab3JMDVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Oct 2013 23:21:20 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:28PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> EXT4_FEATURE_INCOMPAT_INLINE_DATA flag is added into
> EXT2_LIB_SOFTSUPP_INCOMPAT due to we still need to take a long time to
> test inline_data feature.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied to the next branch, thanks.

					- Ted
