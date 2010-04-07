From: tytso@mit.edu
Subject: Re: [PATCH] ext4: check for EXT4_MB_HINT_NOPREALLOC is added in
 ext4_mb_use_preallocated()
Date: Wed, 7 Apr 2010 11:17:14 -0400
Message-ID: <20100407151714.GP23670@thunk.org>
References: <w2mac8f92701004070625r59b28db9o843ef4dbd95c3428@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab0DGP5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 11:57:24 -0400
Content-Disposition: inline
In-Reply-To: <w2mac8f92701004070625r59b28db9o843ef4dbd95c3428@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07, 2010 at 09:25:53PM +0800, jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Wed Apr 7 21:23:48     2010
> 
> Since preallocation may not be require by allocation request, check
> for it in ext4_mb_use_preallocated() seems necessary.

NACK.  If there is a file-specific preallocation that had been created
from a previous allocation (that wasn't completely used up), we want
to use it up, even if we don't want to create any new per-file
preallocations.

						- Ted
