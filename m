From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2image: handle SIGINT safely
Date: Tue, 24 Dec 2013 23:58:49 -0500
Message-ID: <20131225045849.GE13142@thunk.org>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
 <1381247792-22508-5-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43209 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3LYE6v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Dec 2013 23:58:51 -0500
Content-Disposition: inline
In-Reply-To: <1381247792-22508-5-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:56:32AM -0400, Phillip Susi wrote:
> When doing an in place move, interrupting it past the
> point of no return will destroy the filesystem since
> parts of it have been overwritten.  Catch SIGINT the
> first time and issue a warning if this is the case.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Thanks, applied.

					- Ted
