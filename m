From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/2] ext4: Use EXT_MAX_BLOCKS in ext4_es_can_be_merged()
Date: Mon, 12 May 2014 22:25:43 -0400
Message-ID: <20140513022543.GA28803@thunk.org>
References: <1397585302-27175-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35844 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbaEMCZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 22:25:46 -0400
Content-Disposition: inline
In-Reply-To: <1397585302-27175-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 08:08:22PM +0200, Lukas Czerner wrote:
> In ext4_es_can_be_merged() when checking whether we can merge two
> extents we should use EXT_MAX_BLOCKS instead of defining it manually.
> Also if it is really the case we should notify userspace because clearly
> there is a bug in extent status tree implementation since this should
> never happen.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

					- Ted
