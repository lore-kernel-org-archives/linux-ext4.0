From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] xfstests-bld: get-results: add -a option for grep,
 to process binary files as text
Date: Mon, 14 Apr 2014 10:00:26 -0400
Message-ID: <20140414140026.GA7288@thunk.org>
References: <1397297243-12130-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54145 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbaDNOAb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2014 10:00:31 -0400
Content-Disposition: inline
In-Reply-To: <1397297243-12130-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 02:07:22PM +0400, Azat Khuzhin wrote:
> Since logs can have some _non ASCII_ symbols and grep think that this is
> a binary file.
> 
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

Thanks, applied.

					- Ted
