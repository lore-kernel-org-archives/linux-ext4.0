From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: Wed, 24 Sep 2014 11:35:31 -0400
Message-ID: <20140924153531.GK17784@thunk.org>
References: <20140924014744.GJ17784@thunk.org>
 <20140924030828.18454.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46309 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbaIXPff (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Sep 2014 11:35:35 -0400
Content-Disposition: inline
In-Reply-To: <20140924030828.18454.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2014 at 11:08:28PM -0400, George Spelvin wrote:
> > Still, it would probably simpler to not try to assign
> > DX_HASH_SIPHASH24 to be 6, and to leave better comments about how the
> > hash values are used.
> 
> Is that "not try" supposed to be in there?

Sorry, typo.  Yes, it would be better to assign DX_HASH_SIPHASH24 to
be 6, and not to assign the code points 3, 4, and 5 just to be safe.

> BTW, initial benchmarking isn't showing much.  I created a 4 GB file
> syste, on a RAM disk with -i 1024, and tried the following:

> DEV=/tmp/FS
> MNT=/mnt

(I assume you're using tmpfs.)  There would be less overhead if you
actually used a real ramdisk, i.e., /dev/ram0, which might reduce some
of the variance and increase the percentage of the difference, but
yeah, it's not that surprising that we're not seeing much difference.

      	       	    	       	    	  - Ted
