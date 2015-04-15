From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4 crypto: type bug with encrypted symlinks
Date: Wed, 15 Apr 2015 12:45:36 -0400
Message-ID: <20150415164536.GA25331@thunk.org>
References: <20150415092133.GA9264@mwanda>
 <1591C866-F48B-4F82-B2D1-7F7180E3EE2A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1591C866-F48B-4F82-B2D1-7F7180E3EE2A@dilger.ca>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 15, 2015 at 09:14:17AM -0600, Andreas Dilger wrote:
> Nak.  ostr.len is the variable being swabbed, and it is a __u32.

No, Dan is right; sd->len has been changed to be 16 bits on disk, per
Andreas' suggestion, and I missed changing the cpu_to_le32() to be
cpu_to_le16() here.  The fact that the in-memory representation
happens to be 32-bits doesn't matter, it's the fact that on-disk
representation is 16-bits which is important here.

In practice the filename length can never be larger
i_sb->s_blocksize(), so we could probably change struct ext4_str to
use an __u16 --- but at least at one point RISC architectues can
sometimes handle 32-bit values more efficiently than 16-bit values,
and it's probably not worth the effort to make the change.

    	 	      	    	- Ted
