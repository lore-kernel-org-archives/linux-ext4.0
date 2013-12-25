From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] e2image: add offset switches
Date: Tue, 24 Dec 2013 23:58:15 -0500
Message-ID: <20131225045815.GB13142@thunk.org>
References: <52AF2A8E.8030207@ubuntu.com>
 <1387211559-25743-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43199 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab3LYE6U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Dec 2013 23:58:20 -0500
Content-Disposition: inline
In-Reply-To: <1387211559-25743-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 11:32:39AM -0500, Phillip Susi wrote:
> Add -o and -O switches to specify the offset where the source
> and destination filesystems start.  This is useful if you have
> an image of a partitioned disk or wish to create one.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Thanks, applied.

					- Ted
