From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: fix a bug of leaking jh->b_jcount
Date: Thu, 26 May 2011 11:16:13 -0400
Message-ID: <20110526151613.GM9520@thunk.org>
References: <1306376902-13308-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33009 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab1EZPQQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 11:16:16 -0400
Content-Disposition: inline
In-Reply-To: <1306376902-13308-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2011 at 10:28:22AM +0800, Ding Dinghua wrote:
> jbd2_journal_get_create_access should drop jh->b_jcount in error
> handling path
> 
> Signed-off-by: Ding Dinghua <dingdinghua@nrchpc.ac.cn>

Thanks, merged into the ext4 tree.

					- Ted
