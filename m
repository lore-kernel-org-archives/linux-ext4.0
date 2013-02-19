From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and
 'dev' branch
Date: Tue, 19 Feb 2013 09:55:29 +0100
Message-ID: <20130219085529.GA21945@quack.suse.cz>
References: <20130217172208.GB4059@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab3BSJDe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2013 04:03:34 -0500
Content-Disposition: inline
In-Reply-To: <20130217172208.GB4059@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon 18-02-13 01:22:08, Zheng Liu wrote:
> Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
> remember that there has a patch for ext4 to fix filesystem freeze bug
> but I am not sure whether it can fix this bug and it has been applied
> into 'dev' branch.  So I file this bug here.
  Yes, I also recently hit this bug. I found that the root cause is that in
data=journal mode there are dirty pages even after syncing the whole
filesystem. I didn't yet found out why that happens but dirty page handling
is complex in data=journal mode as pages get marked dirty at the moment
transaction is committing and buffers are filed into checkpoint lists so I
find it quite possible there is some case I didn't think about where
syncing results in non-clean filesystem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
