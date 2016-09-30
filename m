From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH 2/2] ext4: use journal inode to determine journal
 overhead
Date: Fri, 30 Sep 2016 02:12:15 -0400
Message-ID: <20160930061215.ur24zfdoilcqpqmu@thunk.org>
References: <20160922150752.GA14239@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47692 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935929AbcI3GMW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 02:12:22 -0400
Content-Disposition: inline
In-Reply-To: <20160922150752.GA14239@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2016 at 11:07:52AM -0400, Eric Whitney wrote:
> When a file system contains an internal journal that has not been
> loaded, use the journal inode's i_size field to determine its
> contribution to the file system's overhead.  (The journal's j_maxlen
> field is normally used to determine its size, but it's unavailable when
> the journal has not been loaded.)
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

							- Ted
