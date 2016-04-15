From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: don't leak progress info to stdout
Date: Fri, 15 Apr 2016 11:11:23 -0400
Message-ID: <20160415151123.GB11838@thunk.org>
References: <57105E0E.1040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Markley <alex@malexmedia.net>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59870 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbcDOPL1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 11:11:27 -0400
Content-Disposition: inline
In-Reply-To: <57105E0E.1040006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2016 at 10:20:46PM -0500, Eric Sandeen wrote:
> Commit c8ee0d60 fixed most of these, but missed this one.
> 
> # e2image -r -p <device> - > imagefile
> 
> leads to a corrupted image due to the "Scanning inodes..."
> printf going to stdout.
> 
> Reported-by: Alex Markley <alex@malexmedia.net>
> Addresses-Red-Hat-Bugzilla: #1327329
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
