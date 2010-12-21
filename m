From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/15] mke2fs: check return value of e2p_os2string()
Date: Tue, 21 Dec 2010 18:13:45 -0500
Message-ID: <20101221231345.GB5700@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-10-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40794 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab0LUXNr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 18:13:47 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-10-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:11PM +0900, Namhyung Kim wrote:
> e2p_os2string() calls malloc() so that it can return NULL.
> Check it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks for reporting this, I fixed this problem in a slightly
different way.

		       	    	     - Ted
