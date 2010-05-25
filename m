From: tytso@mit.edu
Subject: Re: [PATCH 3/6] ext4: Use our own write_cache_pages()
Date: Tue, 25 May 2010 09:06:26 -0400
Message-ID: <20100525130626.GD5556@thunk.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-4-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52820 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0EYNGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 09:06:31 -0400
Content-Disposition: inline
In-Reply-To: <1274784852-30502-4-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 08:54:09PM +1000, Dave Chinner wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> Make a copy of write_cache_pages() for the benefit of
> ext4_da_writepages().  This allows us to simplify the code some, and
> will allow us to further customize the code in future patches.

I'm going to be pushing this to Linus shortly, so it's likely you'll
be able to drop this from your patch series.  I just wanted to give
you a heads up about what I was planning on doing, which hopefully
simplified your life a little.

      	       	      	  	   	      - Ted
