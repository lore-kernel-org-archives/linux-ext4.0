From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: build: fix unused/uninitialized variable warnings
Date: Fri, 25 Jul 2014 21:44:26 -0400
Message-ID: <20140726014426.GA12583@thunk.org>
References: <1406098712-7147-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57682 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaGZBoa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 21:44:30 -0400
Content-Disposition: inline
In-Reply-To: <1406098712-7147-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 23, 2014 at 12:58:32AM -0600, Andreas Dilger wrote:
> Fix a few warnings about unused and uninitialized variables.
> 
> Also fix util/subst.c to include <sys/time.h> to avoid using
> undeclared functions gettimeofday() and futimes().
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
