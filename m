From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: return -ENOMEM instead of success
Date: Sat, 10 Dec 2016 09:58:34 -0500
Message-ID: <20161210145834.i6uizxma4625kb2p@thunk.org>
References: <20161207112106.GB5507@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <boyu.mt@taobao.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41074 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbcLJWte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Dec 2016 17:49:34 -0500
Content-Disposition: inline
In-Reply-To: <20161207112106.GB5507@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2016 at 02:21:06PM +0300, Dan Carpenter wrote:
> We should set the error code if kzalloc() fails.
> 
> Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
