From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: correct comment references to ext4_ext_direct_IO()
Date: Sun, 30 Jul 2017 22:28:44 -0400
Message-ID: <20170731022844.kqxvw273xoge3ltd@thunk.org>
References: <20170714210426.GB12793@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47200 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751760AbdGaC2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Jul 2017 22:28:46 -0400
Content-Disposition: inline
In-Reply-To: <20170714210426.GB12793@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 14, 2017 at 05:04:26PM -0400, Eric Whitney wrote:
> Commit 914f82a32d0268847 "ext4: refactor direct IO code" deleted
> ext4_ext_direct_IO(), but references to that function remain in
> comments.  Update them to refer to ext4_direct_IO_write().
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
