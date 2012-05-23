From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 01/10] string: introduce memweight
Date: Wed, 23 May 2012 07:16:00 -0600
Message-ID: <20120523131559.GA7064@parisc-linux.org>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com> <20120523092113.GG10452@quack.suse.cz> <CAC5umyi=ridqRZGGh0+_xw0-GCN+69B33Qz82-9x4dVODGGx6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Anders Larsen <al@alarsen.net>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45411 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2EWNQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2012 09:16:04 -0400
Content-Disposition: inline
In-Reply-To: <CAC5umyi=ridqRZGGh0+_xw0-GCN+69B33Qz82-9x4dVODGGx6w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 23, 2012 at 09:12:18PM +0900, Akinobu Mita wrote:
> size_t memweight(const void *ptr, size_t bytes)

Why should this return size_t instead of unsigned long?

> {
> 	size_t w = 0;
> 	size_t longs;
> 	const unsigned char *bitmap = ptr;
> 
> 	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
> 			bytes--, bitmap++)
> 		w += hweight8(*bitmap);
> 
> 	longs = bytes / sizeof(long);
> 	BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
> 	w += bitmap_weight((unsigned long *)bitmap, longs * BITS_PER_LONG);
> 	bytes -= longs * sizeof(long);
> 	bitmap += longs * sizeof(long);
> 
> 	for (; bytes > 0; bytes--, bitmap++)
> 		w += hweight8(*bitmap);
> 
> 	return w;
> }

bitmap_weight copes with a bitmask that isn't a multiple of BITS_PER_LONG
in size already.  So I think this can be done as:

unsigned long memweight(const void *s, size_t n)
{
	const unsigned char *ptr = s;
	unsigned long r = 0;

	while (n > 0 && (unsigned long)ptr % sizeof(long)) {
		r += hweight8(*ptr);
		n--;
		ptr++;
	}

	BUG_ON(n >= INT_MAX / 8)

	return r + bitmap_weight((unsigned long *)ptr, n * 8);
}

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
