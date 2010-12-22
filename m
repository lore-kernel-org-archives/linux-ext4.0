From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 12/15] mke2fs: add some error checks into PRS()
Date: Tue, 21 Dec 2010 20:34:30 -0500
Message-ID: <20101222013430.GE5700@thunk.org>
References: <1291205003.1684.12.camel@leonhard>
 <1292492440-6778-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59033 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0LVBeh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 20:34:37 -0500
Content-Disposition: inline
In-Reply-To: <1292492440-6778-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 16, 2010 at 06:40:40PM +0900, Namhyung Kim wrote:
> Check return value of some functions and exit if unhandled error occurred.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

It's actually ok to continue if the error tables aren't initialized,
so we don't need to add error checking for them.  I've add the patch
(minus this hunk) to the next branch.

      	    	    	      	       	   - Ted
