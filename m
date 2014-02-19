From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix error return from
 ext4_ext_handle_uninitialized_extents()
Date: Wed, 19 Feb 2014 18:58:26 -0500
Message-ID: <20140219235826.GA18781@thunk.org>
References: <20140213225430.GC11924@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60205 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaBSX6d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 18:58:33 -0500
Content-Disposition: inline
In-Reply-To: <20140213225430.GC11924@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 13, 2014 at 05:54:30PM -0500, Eric Whitney wrote:
> Commit 3779473246 breaks the return of error codes from
> ext4_ext_handle_uninitialized_extents() in ext4_ext_map_blocks().  A
> portion of the patch assigns that function's signed integer return
> value to an unsigned int.  Consequently, negatively valued error codes
> are lost and can be treated as a bogus allocated block count.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
