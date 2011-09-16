From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/25] e2fsprogs: Don't try to close an fd which is
 negative
Date: Fri, 16 Sep 2011 19:57:43 -0400
Message-ID: <20110916235743.GB16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-24-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48993 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1IPX5p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 19:57:45 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-24-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:38PM -0500, Eric Sandeen wrote:
> These reflect either file descriptors which aren't tested
> for failure, or closures of fd's which may have failed.
> 
> In setup_tdb(), test for failure of mkstemp and return
> without trying to open the file (again).
> 
> In reserve_stdio_fds, rather than closing the "extra"
> fd == 3 due to the way the loop is written, just
> don't go that far by using while (fd <= 2).
> 
> In logsave, it forks and retries forever if open fails,
> but at least make coverity happy by explicitly not
> trying to close a negative file descriptor.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
