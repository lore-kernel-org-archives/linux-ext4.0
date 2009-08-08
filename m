From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: buffer underrun in ext4_ext_split()?
Date: Fri, 7 Aug 2009 23:32:07 -0400
Message-ID: <20090808033207.GC8831@mit.edu>
References: <4A7C7045.7040704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52056 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbZHHDcN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2009 23:32:13 -0400
Content-Disposition: inline
In-Reply-To: <4A7C7045.7040704@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 07, 2009 at 08:19:49PM +0200, Roel Kluin wrote:
> If `depth' is less or equal to `at', a buffer underrun occurs
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I am not sure whether this is possible.

I'm pretty sure this could never happen.  ext4_ext_split is only
called from one place, and only when the leaf node is full.

       	    	       	   	     	      - Ted
