From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: avoid eh_entries overflow before insert
 extent_idx
Date: Sun, 17 Jul 2011 23:46:26 -0400
Message-ID: <20110718034626.GE14869@thunk.org>
References: <1309156180-3899-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab1GRDq3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 23:46:29 -0400
Content-Disposition: inline
In-Reply-To: <1309156180-3899-1-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 27, 2011 at 02:29:40PM +0800, Robin Dong wrote:
> If eh_entries is equal to (or greater than) eh_max, the operation of
> inserting new extent_idx will make number of entries overflow.
> So check eh_entries before inserting the new extent_idx.
> 
> Although there is no bug case according the code (function ext4_ext_insert_index 
> is called by ext4_ext_split and ext4_ext_split is called only if the index
> block has free space), the right logic should be "lookup the capacity before
> insertion".
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, added to the ext4 tree.

						- Ted
