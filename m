From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in
	64k blocksize filesystems
Date: Wed, 11 Feb 2009 10:15:47 -0500
Message-ID: <20090211151547.GK29220@mini-me.lan>
References: <4990FAE4.1080009@cn.fujitsu.com> <20090210152049.GF30689@mini-me.lan> <20090211054816.GP3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33763 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZBKPQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 10:16:14 -0500
Content-Disposition: inline
In-Reply-To: <20090211054816.GP3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 11, 2009 at 12:48:16AM -0500, Andreas Dilger wrote:
> 
> I'm glad that the MAX_REC_LEN value is being kept, because "0" is
> too easily hit due to disk corruption.
> 

I'm not too worried about that, actually.  If there is a disk
corruption, we will detect it easily enough no matter which encoding
we use.  I am thinking though that neither 65535 nor 0 is the best way
of encoding 65536.  In fact, I would suggest the encoding 0x01.
Specifically, I suggest:

	     (rec_len & 65532) | ((rec_len >> 16) & 3)

This encodes valid rec_len values in the range 0 through 2**18-4, and
allows for maximum block sizes of up to 256k.  To retain backwards
compatibility, and to allow for a 256k blocksize, we can have a
special case where a rec_len of either 0 or 65535 means
EXT4_BLOCK_SIZE(s).

It's unlikely we'll see VM pages of up to 256k, but at some point we
might find that the Linux VM has been enhanced to support filesystem
block sizes > than the VM page size, at which point it might be useful
for some applications to allow very large filesystem block sizes.

    	 	      	       	    	  	     - Ted
