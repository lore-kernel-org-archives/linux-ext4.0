From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: silence build warning and remove incorrect
 error message
Date: Tue, 24 Dec 2013 11:05:17 -0500
Message-ID: <20131224160517.GD26944@thunk.org>
References: <20131223023035.GA2396@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43085 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab3LXQFU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Dec 2013 11:05:20 -0500
Content-Disposition: inline
In-Reply-To: <20131223023035.GA2396@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 22, 2013 at 09:30:35PM -0500, Eric Whitney wrote:
> Commit fe56188b07 modified the code used to check the block number
> argument to the command line -s switch, adding a call to com_err().
> This causes a compile time warning because the third argument to
> com_err() isn't a string.  Also, when the block number argument is
> bad it outputs an incorrect error message - "Operation not permitted".
> 
> Fix these minor problems by removing the call to com_err().  Other
> code provides enough error reporting information in this case.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

						- Ted
