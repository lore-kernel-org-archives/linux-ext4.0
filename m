From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: delete path dealloc code in
 ext4_ext_handle_uninitialized_extents
Date: Thu, 13 Mar 2014 23:26:13 -0400
Message-ID: <20140314032613.GC8282@thunk.org>
References: <20140226203914.GA2153@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41184 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbaCND0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2014 23:26:16 -0400
Content-Disposition: inline
In-Reply-To: <20140226203914.GA2153@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 26, 2014 at 03:39:14PM -0500, Eric Whitney wrote:
> Code deallocating the extent path referenced by an argument to
> ext4_ext_handle_uninitialized_extents was made redundant with identical
> code in its one caller, ext4_ext_map_blocks, by commit 3779473246.
> Allocating and deallocating the path in the same function also makes
> the code clearer.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
