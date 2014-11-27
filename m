From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix sparse warnings with new shash api usage
Date: Thu, 27 Nov 2014 00:32:40 -0500
Message-ID: <20141127053240.GC4004@thunk.org>
References: <20141126235109.GO10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54343 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbaK0Fcp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Nov 2014 00:32:45 -0500
Content-Disposition: inline
In-Reply-To: <20141126235109.GO10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2014 at 03:51:09PM -0800, Darrick J. Wong wrote:
> Use __le32, not u32 so that sparse is happy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, I'll fold this into the shash api patch.

	     	       	    	      - Ted
