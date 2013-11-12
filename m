From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Add missing brelse to xattr code.
Date: Mon, 11 Nov 2013 20:08:36 -0500
Message-ID: <20131112010836.GA30433@thunk.org>
References: <20131106154546.GA27255@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57031 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab3KLMn1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Nov 2013 07:43:27 -0500
Content-Disposition: inline
In-Reply-To: <20131106154546.GA27255@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 06, 2013 at 10:45:46AM -0500, Dave Jones wrote:
> This code was recently patched to not leak memory on the retry path,
> but it seems we are also forgetting to brelse the bufferhead.
>    
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Thanks, I have this fix in my tree already.

Cheers,

					- Ted

commit dcb9917ba041866686fe152850364826c4622a36
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Oct 31 23:00:24 2013 -0400

    ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()
    
    Reported-by: Dave Jones <davej@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 03e9beb..1423c48 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1352,6 +1352,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;

