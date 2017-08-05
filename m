From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: silence array overflow warning
Date: Sat, 5 Aug 2017 19:01:18 -0400
Message-ID: <20170805230118.5olcshags2qerb6y@thunk.org>
References: <20170718092702.bpk2k5qjg4cz2mqk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41134 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbdHEXBV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 5 Aug 2017 19:01:21 -0400
Content-Disposition: inline
In-Reply-To: <20170718092702.bpk2k5qjg4cz2mqk@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 12:27:02PM +0300, Dan Carpenter wrote:
> I get a static checker warning:
> 
>     fs/ext4/ext4.h:3091 ext4_set_de_type()
>     error: buffer overflow 'ext4_type_by_mode' 15 <= 15
> 
> It seems unlikely that we would hit this read overflow in real life, but
> it's also simple enough to make the array 16 bytes instead of 15.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
