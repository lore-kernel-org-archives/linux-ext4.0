From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
	size
Date: Mon, 8 Jun 2009 09:31:29 -0400
Message-ID: <20090608133129.GH23883@mit.edu>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56221 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZFHNbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2009 09:31:32 -0400
Content-Disposition: inline
In-Reply-To: <20090605212000.GV9002@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 05, 2009 at 03:20:00PM -0600, Andreas Dilger wrote:
> There are a number of other places where there are limits related
> to > 64kB blocksize like ext4_dir_entry_2 itself having only a
> "__u16 rec_len", so without changing the on-disk format it is not
> possible to have > 64kB blocksize.

That situation we have dealt with already, at least in the kernel:

unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
{
	unsigned len = le16_to_cpu(dlen);

	if (len == EXT4_MAX_REC_LEN || len == 0)
		return blocksize;
	return (len & 65532) | ((len & 3) << 16);
}

We do *not* have support in e2fsprogs using this this algorithm, so
there are some bugs to be fixed, though.  But the kernel at least
theoretically handles this case correctly.  That's not to say there
might not be other places where this is buggy, but fundamentally it's
not impossible for us to support block sizes up to 256k, at least from
an on-disk filesystem format perspective.

	  	     	  	      	   	   - Ted
