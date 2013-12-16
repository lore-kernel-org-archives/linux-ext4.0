From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2image: perform in-place move
Date: Sun, 15 Dec 2013 23:33:38 -0500
Message-ID: <20131216043338.GD28536@thunk.org>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
 <1381247792-22508-3-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40356 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3LPEdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:33:40 -0500
Content-Disposition: inline
In-Reply-To: <1381247792-22508-3-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:56:30AM -0400, Phillip Susi wrote:
> If given at least one offset and only one file, assume source
> and dest are the same, and do an in place move.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

You **really** only want to allow move_mode if you are in raw mode.
In particular, the safe move isn't even implemented in the other mods
(nor does it make any sense), and if the user simply forgot to specify
-r, it would be a shame if it ended up destroying the user's file
system.  :-(

						- Ted
