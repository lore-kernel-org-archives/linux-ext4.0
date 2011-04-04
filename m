From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Move bdget out of critical section
Date: Mon, 4 Apr 2011 12:36:34 -0400
Message-ID: <20110404163634.GD4706@thunk.org>
References: <1301734876-22207-1-git-send-email-gaoyang.zyh@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Zhu Yanhai <gaoyang.zyh@taobao.com>
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33950 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1DDQgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 12:36:38 -0400
Content-Disposition: inline
In-Reply-To: <1301734876-22207-1-git-send-email-gaoyang.zyh@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 02, 2011 at 05:01:16PM +0800, Zhu Yanhai wrote:
> bdget() should not be called when we hold spinlocks since
> it might sleep.
> 
> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>

I've added the patch to the patch queue.  Technically we should never
have a problem, though, since we only use this for the journal inode,
which is not going to be a fresly created inode.  So I don't think we
should ever hit the paths that will result in the kernel sleeping.
But I agree it's better to move it out, if for no other reason to make
life easier for static checkers.

          	       	     	       	    - Ted
