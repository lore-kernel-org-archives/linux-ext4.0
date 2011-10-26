From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: remove unused argument in mb_find_extent
Date: Wed, 26 Oct 2011 05:34:05 -0400
Message-ID: <20111026093405.GU31921@thunk.org>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
 <1316070580-10723-3-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46717 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab1JZJeI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 05:34:08 -0400
Content-Disposition: inline
In-Reply-To: <1316070580-10723-3-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 03:09:39PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The argument 'ord' in function mb_find_extent is redundant,
> so remove it.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, applied.

In both this and the previous patch, I changed "argument" to
"variable" for clarity/correctness in the git commit log.

	       			      	  - Ted
