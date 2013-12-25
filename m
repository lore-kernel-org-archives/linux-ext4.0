From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2image: perform in-place move
Date: Tue, 24 Dec 2013 23:58:26 -0500
Message-ID: <20131225045826.GC13142@thunk.org>
References: <52AF2AC0.2030103@ubuntu.com>
 <1387211599-25789-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ttytso@mit.edu, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43202 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3LYE62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Dec 2013 23:58:28 -0500
Content-Disposition: inline
In-Reply-To: <1387211599-25789-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 11:33:19AM -0500, Phillip Susi wrote:
> If given at least one offset and only one file, assume source
> and dest are the same, and do an in place move.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Thanks, applied.

				- Ted
