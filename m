From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] EXT4: fix online resize bug
Date: Wed, 4 Jun 2008 21:53:31 -0400
Message-ID: <20080605015330.GA10488@mit.edu>
References: <20080529181941.GG23090@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57179 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbYFEBxs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 21:53:48 -0400
Content-Disposition: inline
In-Reply-To: <20080529181941.GG23090@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 29, 2008 at 02:19:41PM -0400, Josef Bacik wrote:
> Hello,
> 
> There is a bug when we are trying to verify that the reserve inode's double
> indirect blocks point back to the primary gdt blocks.  The fix is obvious, we
> need to mod the gdb count by the addr's per block.  This was verified using the
> same testcase as with the ext3 equivalent of this patch.  Thank you,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
