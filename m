From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: remove #ifdef EXT2_NO_64_TYPE blocks
Date: Wed, 5 Jul 2017 00:09:32 -0400
Message-ID: <20170705040932.dgunegf2qldfr76p@thunk.org>
References: <20170628012240.9141-1-tahsin@google.com>
 <C15DD822-2183-477D-8F3F-E58E0027124F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47748 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbdGEEJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Jul 2017 00:09:34 -0400
Content-Disposition: inline
In-Reply-To: <C15DD822-2183-477D-8F3F-E58E0027124F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 28, 2017 at 10:38:20AM -0600, Andreas Dilger wrote:
> On Jun 27, 2017, at 7:22 PM, Tahsin Erdogan <tahsin@google.com> wrote:
> > 
> > EXT2_NO_64_TYPE is not defined anywhere. It appears to be a
> > historical artifact.
> > 
> > Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
