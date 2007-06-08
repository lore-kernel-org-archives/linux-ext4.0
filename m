From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Fri, 8 Jun 2007 11:36:00 -0400
Message-ID: <20070608153600.GA9726@thunk.org>
References: <4665479E.2060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51006 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbXFHWq1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2007 18:46:27 -0400
Content-Disposition: inline
In-Reply-To: <4665479E.2060707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In addition to the comments already posted:

> +/* check it manually as using LUKS_read_phdr from libcryptsetup
> + * prints too many warnings if it isn't a luks partition and would add a
> + * dependency on the lib */
> +static int probe_luks(struct blkid_probe *probe,
> +		       struct blkid_magic *id __BLKID_ATTR((unused)), 
> +		       unsigned char *buf)
> +{
> +	const char *luks_magic = id->bim_magic;
> +	unsigned char *p_buf = buf;
> +	unsigned char uuid[40];
> +	if(strncmp(buf, luks_magic, strlen(luks_magic)) == 0)   /* ID matches, continue */

There's no point in doing this check, since it's replicating a check
already done in the generic code.  The probe function won't be called
if the bim_magic didn't match the specified offset. 

						- Ted
