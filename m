From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: acl: remove unneeded include of
 linux/capability.h
Date: Mon, 24 Mar 2014 19:00:00 -0400
Message-ID: <20140324230000.GB13535@thunk.org>
References: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jakub Sitnicki <jsitnicki@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45480 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaCXXAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2014 19:00:13 -0400
Content-Disposition: inline
In-Reply-To: <1395645732-26569-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2014 at 08:22:12AM +0100, Jakub Sitnicki wrote:
> acl.c has not been (directly) using the interface defined by
> linux/capability.h header since commit 3bd858ab1c451725c07a
> ("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
> check"). Remove it.
> 
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>

Thanks, applied.

					- Ted
