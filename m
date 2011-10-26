From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: remove unused argument in
 ext4_mb_generate_from_pa
Date: Wed, 26 Oct 2011 05:24:54 -0400
Message-ID: <20111026092454.GT31921@thunk.org>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
 <1316070580-10723-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57103 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571Ab1JZJY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 05:24:57 -0400
Content-Disposition: inline
In-Reply-To: <1316070580-10723-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 03:09:38PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The argument 'count' in function ext4_mb_generate_from_pa looks useless,
> so clean it.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, applied.

					- Ted
