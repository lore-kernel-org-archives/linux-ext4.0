From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix comment to match the code in
 jbd2__journal_start()
Date: Tue, 24 May 2011 17:38:08 -0400
Message-ID: <20110524213808.GE26055@thunk.org>
References: <1306167478-28682-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42005 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab1EXViM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 17:38:12 -0400
Content-Disposition: inline
In-Reply-To: <1306167478-28682-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 12:17:58AM +0800, Eryu Guan wrote:
> jbd2__journal_start() returns an ERR_PTR() value rather than NULL on
> failure.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, added to the ext4 tree.

						- Ted
