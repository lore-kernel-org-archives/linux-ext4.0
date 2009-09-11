From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Always set dx_node's fake_dirent explicitly.
Date: Thu, 10 Sep 2009 23:19:37 -0400
Message-ID: <20090911031937.GA20710@mit.edu>
References: <200908301656.40866.schlick@lavabit.com> <200908301657.50561.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Schlick <schlick@lavabit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48497 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbZIKDTf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 23:19:35 -0400
Content-Disposition: inline
In-Reply-To: <200908301657.50561.schlick@lavabit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 30, 2009 at 04:57:50PM +0200, Andreas Schlick wrote:
> When ext4_dx_add_entry() has to split an index node, it has to ensure that
> name_len of dx_node's fake_dirent is also zero, because otherwise e2fsck
> won't recognise it as an intermediate htree node and consider the htree to
> be corrupted.
> 
> Signed-off-by: Andreas Schlick <schlick@lavabit.com>

Added to the ext4 patch queue, thanks.

					- Ted
