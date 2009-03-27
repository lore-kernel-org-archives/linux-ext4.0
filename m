From: Theodore Tso <tytso@mit.edu>
Subject: Re: locking typo in ext4_mb_add_n_trim()
Date: Fri, 27 Mar 2009 19:36:34 -0400
Message-ID: <20090327233634.GI5176@mit.edu>
References: <Pine.LNX.4.64.0903262204430.4167@usbsys.site> <49CCDFDB.9000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:32859 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764049AbZC0Xgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 19:36:39 -0400
Content-Disposition: inline
In-Reply-To: <49CCDFDB.9000109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 27, 2009 at 09:16:59AM -0500, Eric Sandeen wrote:
> 
> although I wonder why we don't trip over this in spinlock debugging
> (seems like it'd lead to a double unlock at times)  I wonder if we can
> tie this to any other bugs we've seen.

I was wondering if it could be tied to the "rm -rf" soft lockup hang....

I wonder if vendor kernels (specifically, Ubuntu in this case) disable
spinlock debugging, which is why we wouldn't have seen the double
unlock warning.  (Or maybe it happened earlier in the log, and users
didn't notice it).

					- Ted
