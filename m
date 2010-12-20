From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/15] libext2fs: invalid
 EXT4_FEATURE_RO_COMPAT_HUGE_FILE checks
Date: Mon, 20 Dec 2010 10:55:23 -0500
Message-ID: <20101220155523.GM23626@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-7-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39422 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab0LTPzY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 10:55:24 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-7-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:08PM +0900, Namhyung Kim wrote:
> It should be checked with fs->super->s_feature_ro_compat instead of
> ->s_feature_incompat.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

A similar patch has already been applied, thanks.

  	  	    	    	 	  - Ted
