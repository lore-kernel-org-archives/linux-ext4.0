From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] ext4 trace events cause NULL pointer dereferences
Date: Thu, 22 Jul 2010 01:49:57 -0400
Message-ID: <20100722054957.GA11670@infradead.org>
References: <4C401CE3.7010004@cn.fujitsu.com>
 <20100721222508.8704.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0GVFuD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Jul 2010 01:50:03 -0400
Content-Disposition: inline
In-Reply-To: <20100721222508.8704.A69D9226@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 10:31:20PM +0900, KOSAKI Motohiro wrote:
> But, I don't think this is proper fix because we don't want any overhead
> if the tracepoint is disabled.
> 
> So, How do we check NULL in TP_fast_assign()?

I think ext4 is simply using an incorrectly typed tracepoint here.
If you want it to be useful in any way it needs a sb paramter and
an optional inode paramter, not the allocation context.

Also the whole ext4_mb_release_group_pa function seems to be a bit
misdesigned.  The code using ac is a totally separate block at the
end of the function and does work that's unrelated to the rest
of the function.  Just making it a separate helper can calling it
only from those places that have the allocation context would make
the code more clear.
