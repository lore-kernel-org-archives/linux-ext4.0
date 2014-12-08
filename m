From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/jbd2: fix race condition when initializing the
 crc32c "key"
Date: Mon, 8 Dec 2014 10:33:35 -0500
Message-ID: <20141208153335.GC7001@thunk.org>
References: <20141205035539.GF10059@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45513 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbaLHPdj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Dec 2014 10:33:39 -0500
Content-Disposition: inline
In-Reply-To: <20141205035539.GF10059@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 04, 2014 at 07:55:39PM -0800, Darrick J. Wong wrote:
> In the patch "ext4: use the shash api correctly for crc32c", we
> attempted to correct for the mis-use of crc32c driver internals by
>
> (You could also just revert the two cleanup patches, since every other
> caller of crc32c makes layout and size assumptions.)

OK, I'll just drop the "use the shash api correctly for crc32c" patch.

    	      	       	    	      	  - Ted
