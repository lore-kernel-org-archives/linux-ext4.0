From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: verify extent header depth
Date: Fri, 15 Jul 2016 00:22:48 -0400
Message-ID: <20160715042248.GD26465@thunk.org>
References: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
 <20160707005447.GA19871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55858 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbcGOEWv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jul 2016 00:22:51 -0400
Content-Disposition: inline
In-Reply-To: <20160707005447.GA19871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2016 at 08:54:47PM -0400, Theodore Ts'o wrote:
> So we could arbitrarily limit eh_depth to say, 32 levels, or some
> such.  That will prevent the malicious corruption, while also making
> it very difficult for the malicious fallocate/punch hole workload
> scenario to be triggered.

I've decided to apply your patch with the limit raised to 32.  That
should be enough to prevent the malicious corruption cases.

       	  	    	    		  - Ted
