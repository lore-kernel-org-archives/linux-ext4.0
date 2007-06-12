From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Tue, 12 Jun 2007 19:40:05 -0400
Message-ID: <20070612234004.GA12189@thunk.org>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56614 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbXFMCMN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2007 22:12:13 -0400
Content-Disposition: inline
In-Reply-To: <466D373C.6000502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 11, 2007 at 01:51:24PM +0200, Karsten Hopp wrote:
> +static int probe_luks(struct blkid_probe *probe,
> +		       struct blkid_magic *id __BLKID_ATTR((unused)), 
> +		       unsigned char *buf)
> +{
> +	unsigned char *p_buf = buf;
> +	unsigned char uuid[40];
> +	/* 168 is the offset to the 40 character uuid: 
> +	 * http://luks.endorphin.org/LUKS-on-disk-format.pdf */
> +	p_buf += 168;
> +	strncpy(uuid, p_buf, 40);

Why bother with p_buf?  It would actually be shorter and sweeter to
do:

	strncpy(uuid, buf+168, 40);

And remove the lines dealing with p_buf above.

> +  { "crypt_LUKS",0,	 0,  6,	"LUKS\xba\xbe",		probe_luks },

Any particular reason to use "crypt_LUKS" instead of just "LUKS"?  In
your documentation you generally just refer to it as LUKS.

					- Ted
