From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: avoid wasted extent cache lookup if
 !PUNCH_OUT_EXT
Date: Sun, 17 Jul 2011 23:28:58 -0400
Message-ID: <20110718032858.GD14869@thunk.org>
References: <1309309071-2244-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54913 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1GRD3A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 23:29:00 -0400
Content-Disposition: inline
In-Reply-To: <1309309071-2244-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 29, 2011 at 08:57:51AM +0800, Robin Dong wrote:
> This patch avoids an extraneous lookup of the extent cache
> in ext4_ext_map_blocks() when the flag
> EXT4_GET_BLOCKS_PUNCH_OUT_EXT is absent.
> 
> The existing logic was performing the lookup but not making
> use of the result. The patch simply reverses the order of evaluation
> in the condition.
> 
> Since ext4_ext_in_cache() does not initialize newex on misses, bypassing
> its invocation does not introduce any new issue in this regard.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Eric Gouriou <egouriou@google.com>

Thanks added to the ext4 tree.

						- Ted
