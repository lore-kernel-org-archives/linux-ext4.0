From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: update c/mtime on truncate up
Date: Tue, 28 Jul 2015 15:09:44 -0400
Message-ID: <20150728190944.GN2851@thunk.org>
References: <1437720998-1208-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zirong Lang <zorro.lang@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36459 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbbG1TJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jul 2015 15:09:45 -0400
Content-Disposition: inline
In-Reply-To: <1437720998-1208-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2015 at 02:56:38PM +0800, Eryu Guan wrote:
> Commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <= isize")
> introduced a bug that c/mtime is not updated on truncate up.
> 
> Fix the issue by setting c/mtime explicitly in the truncate up case.
> 
> Note that ftruncate(2) is not affected, so you won't see this bug using
> truncate(1) and xfs_io(1).
> 
> Signed-off-by: Zirong Lang <zorro.lang@gmail.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Applied, thanks.

					- Ted
