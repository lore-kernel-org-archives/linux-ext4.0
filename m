From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] mbcache: remove unnecessary module_get/module_put
Date: Sat, 3 Dec 2016 15:41:52 -0500
Message-ID: <20161203204152.ljtscpzx2jbt5foy@thunk.org>
References: <1480227481-98535-1-git-send-email-ebiggers@google.com>
 <1480227481-98535-3-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33550 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbcLCUl4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 3 Dec 2016 15:41:56 -0500
Content-Disposition: inline
In-Reply-To: <1480227481-98535-3-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 26, 2016 at 10:17:59PM -0800, Eric Biggers wrote:
> When mbcache is built as a module, any modules that use it (ext2 and/or
> ext4) will depend on its symbols directly, incrementing its reference
> count.  Therefore, there is no need to do module_get/module_put.
> 
> Also note that since the module_get/module_put were in the mbcache
> module itself, executing those lines of code was already dependent on
> another reference to the mbcache module being held.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
