From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/22] ext4: Create a rocompat flag for extended
 metadata checksumming
Date: Mon, 5 Dec 2011 10:41:33 -0500
Message-ID: <20111205154133.GA5488@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232629.19194.43499.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53773 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab1LEPli (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 10:41:38 -0500
Content-Disposition: inline
In-Reply-To: <20111128232629.19194.43499.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Reviews sent to ext4 list only)

On Mon, Nov 28, 2011 at 03:26:29PM -0800, Darrick J. Wong wrote:
> This patch introduces a rocompat feature flag to signal the presence
> of checksums for metadata blocks.  It also provides storage for a
> precomputed UUID checksum.
> 
> +
> +	/* Precomputed FS UUID checksum */
> +	__u32 s_uuid_csum;

This is really a checksum seed, right?  Calling it a UUID is going to
be confusing because UUID's are expected to be 128 bits, and something
which is 32 bits can't possibly be a universally unique.

I'd suggest calling this "s_csum_seed", and we explain it as a
random seed which is selected when the file system is formatted.

The commit description could also explain that this is used so we can
detect old metadata blocks left over from a previous use of the
storage device.

       	    	     	      	       	    - Ted
