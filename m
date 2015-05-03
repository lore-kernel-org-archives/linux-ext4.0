From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Move check under lock scope to close a race.
Date: Sat, 2 May 2015 23:21:45 -0400
Message-ID: <20150503032145.GF10014@thunk.org>
References: <1428468410-12793-1-git-send-email-dccitaliano@gmail.com>
 <1428468410-12793-2-git-send-email-dccitaliano@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Davide Italiano <dccitaliano@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41737 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbbECDVr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2015 23:21:47 -0400
Content-Disposition: inline
In-Reply-To: <1428468410-12793-2-git-send-email-dccitaliano@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2015 at 09:46:50PM -0700, Davide Italiano wrote:
> fallocate() checks that the file is extent-based and returns
> EOPNOTSUPP in case is not. Other tasks can convert from and to
> indirect and extent so it's safe to check only after grabbing
> the inode mutex.
> 
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>

Thanks, applied.

						- Ted
