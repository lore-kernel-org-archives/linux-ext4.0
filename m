From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] e2image: add offset switches
Date: Sun, 15 Dec 2013 23:32:28 -0500
Message-ID: <20131216043228.GC28536@thunk.org>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com>
 <1381247792-22508-2-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40353 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3LPEcb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:32:31 -0500
Content-Disposition: inline
In-Reply-To: <1381247792-22508-2-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:56:29AM -0400, Phillip Susi wrote:
> Add -o and -O switches to specify the offset where the source
> and destination filesystems start.  This is useful if you have
> an image of a partitioned disk or wish to create one.
> 
> Signed-off-by: Phillip Susi <psusi@ubuntu.com>

Specifying a dest_offset only makes sense in raw mode, no?

	     		      	    	  - Ted
