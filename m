From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove parameter from ext4_xattr_ibody_set()
Date: Mon, 14 Nov 2016 21:58:20 -0500
Message-ID: <20161115025820.frrv7jp7zho66bxb@thunk.org>
References: <20161025221343.GB15502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37744 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753671AbcKOC6W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Nov 2016 21:58:22 -0500
Content-Disposition: inline
In-Reply-To: <20161025221343.GB15502@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2016 at 06:13:43PM -0400, Eric Whitney wrote:
> The parameter "handle" isn't used.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

				- Ted
