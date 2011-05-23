From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix the wrong calculation of t_max_wait in
 update_t_max_wait.
Date: Sun, 22 May 2011 21:47:34 -0400
Message-ID: <20110523014734.GH10009@thunk.org>
References: <1305024499-8826-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48097 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab1EWBri (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 21:47:38 -0400
Content-Disposition: inline
In-Reply-To: <1305024499-8826-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 06:48:19PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> t_max_wait is added in commit 8e85fb3f to indicate how long we
> were waiting for new transaction to start. In commit 6d0bf005,
> it is moved to another function named update_t_max_wait to
> avoid a build warning. But the wrong thing is that the original
> 'ts' is initialized in the start of function start_this_handle
> and we can calculate t_max_wait in the right way. while with
> this change, ts is initialized within the function and t_max_wait
> can never be calculated right.
> 
> This patch moves the initialization of ts to the original beginning
> of start_this_handle and pass it to function update_t_max_wait so
> that it can be calculated right and the build warning is avoided also.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, added to the ext4 tree.

						- Ted
