From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] jbd2: fix null committed data return in undo_access
Date: Mon, 7 Dec 2015 19:44:21 -0500
Message-ID: <20151208004421.GE3094@thunk.org>
References: <1449039255-21833-1-git-send-email-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	ocfs2-devel@oss.oracle.com
To: Junxiao Bi <junxiao.bi@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44337 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbbLHAo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2015 19:44:26 -0500
Content-Disposition: inline
In-Reply-To: <1449039255-21833-1-git-send-email-junxiao.bi@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 02, 2015 at 02:54:15PM +0800, Junxiao Bi wrote:
> commit de92c8caf16c ("jbd2: speedup jbd2_journal_get_[write|undo]_access()")
> introduced jbd2_write_access_granted() to improve write|undo_access
> speed, but missed to check the status of b_committed_data which caused
> a kernel panic on ocfs2.

Thanks, applied.  (And already upstream).

						- Ted
