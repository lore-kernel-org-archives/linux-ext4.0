From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: in ext4_seek_{hole,data}, return -ENXIO for
 negative offsets
Date: Thu, 24 Aug 2017 13:27:20 -0400
Message-ID: <20170824172720.3inhcbeoozw2rdhh@thunk.org>
References: <20170712173232.GB4212@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mateusz S <muttdini@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51060 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdHXR1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 13:27:22 -0400
Content-Disposition: inline
In-Reply-To: <20170712173232.GB4212@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 12, 2017 at 10:32:32AM -0700, Darrick J. Wong wrote:
> NOTE: The pending iomap SEEK_HOLE/DATA conversion patch will make all this
> obsolete; this is a fix more appropriate for pre-4.13 ext4.
> ---
> In the ext4 implementations of SEEK_HOLE and SEEK_DATA, make sure we
> return -ENXIO for negative offsets instead of banging around inside
> the extent code and returning -EFSCORRUPTED.
> 
> Reported-by: Mateusz S <muttdini@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Sorry, I missed this patch earlier.  It's not going to make the 4.13
final, but I'll apply it with a "cc: stable@vger.kernel.org # 4.6" tag
so it can land in 4.13.x as well as older LTS kernels.

     	       	       	  	    - Ted
