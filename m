From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/22] ext4 crypto: add encryption policy checking
Date: Sat, 11 Apr 2015 09:06:37 -0400
Message-ID: <20150411130637.GD6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-7-git-send-email-tytso@mit.edu>
 <6C2E40F9-574A-4EA8-B533-C9D8CCF1C9C3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <muslukhovi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34111 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631AbbDKNGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Apr 2015 09:06:39 -0400
Content-Disposition: inline
In-Reply-To: <6C2E40F9-574A-4EA8-B533-C9D8CCF1C9C3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06, 2015 at 03:31:49PM -0600, Andreas Dilger wrote:
> > +/**
> > + * ext4_to_hex() - Converts to hexadecimal characters
> > + * @dst: Buffer to take hex character representation of contents of
> > + *       src. Must be at least of size (src_size * 2).
> > + * @src: Buffer to be converted to a hex string respresentation.
> > + * @src_size: Number of bytes to convert.
> > + */
> > +void ext4_to_hex(char *dst, char *src, size_t src_size)
> > +{
> > +	int x;
> > +
> > +	for (x = 0; x < src_size; x++)
> > +		sprintf(&dst[x * 2], "%.2x", (unsigned char)src[x]);
> > +}
> 
> I think there is already some code in printk() to handle this?  Looking
> at vsnprintf->hex_string() it looks like "%*ph" would print out up to 64
> bytes as hex.

As it turns out we're not even using ext4_to_hex() any more, so we can
even more simply just delete this whole function.  :-)

							- Ted
