From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/2] ext4: Do not populate extents tree with outdated
 offsets while shifting extents
Date: Sat, 7 Jan 2017 16:27:46 -0500
Message-ID: <20170107212746.6bqohlvik7laij7i@thunk.org>
References: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
 <20170106202601.32722-3-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50926 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754551AbdAGV1v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 7 Jan 2017 16:27:51 -0500
Content-Disposition: inline
In-Reply-To: <20170106202601.32722-3-roman.penyaev@profitbricks.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 06, 2017 at 09:26:01PM +0100, Roman Pen wrote:
> Inside ext4_ext_shift_extents() function ext4_find_extent() is called
> without EXT4_EX_NOCACHE flag, which should prevent cache population.
> 
> This leads to oudated offsets in the extents tree and wrong blocks
> afterwards.
> 
> Patch fixes the problem providing EXT4_EX_NOCACHE flag for each
> ext4_find_extents() call inside ext4_ext_shift_extents function.
> 
> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>

Thanks, applied.

					- Ted
