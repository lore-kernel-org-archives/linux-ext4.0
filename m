From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 12:47:52 -0400
Message-ID: <20080909164752.GO21071@mit.edu>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu> <20080909140929.GA5335@skywalker> <20080909143915.GG21071@mit.edu> <20080909162814.GB5335@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57760 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbYIIQuf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 12:50:35 -0400
Content-Disposition: inline
In-Reply-To: <20080909162814.GB5335@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 09:58:14PM +0530, Aneesh Kumar K.V wrote:
> diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
> index 62189c9..d1bb9d9 100644
> --- a/lib/e2p/fsetflags.c
> +++ b/lib/e2p/fsetflags.c
> @@ -80,9 +80,19 @@ int fsetflags (const char * name, unsigned long flags)
>  	if (fd == -1)
>  		return -1;
>  	f = (int) flags;
> +	if (f & EXT4_EXTENTS_FL) {
> +		/* extent flags is set using  migrate ioctl */
> +		r = ioctl (fd, EXT4_IOC_MIGRATE, NULL);
> +		if (r == -1) {
> +			save_errno = errno;
> +			goto err_out;
> +		}
> +		f = (int)flags & ~EXT4_EXTENTS_FL;
> +	}

No, I wouldn't put this in libe2p; it probably should be in the chattr
program.  If you do it in chattr, it's much easier to have an
user-friendly error message if the EXT4_IOC_MIGRATE ioctl fails.

Also, it should only call EXT4_IOC_MIGRATE if the file was previously
not supporting extents.  Probably a bad idea to unconditionally call
EXT4_IOC_MIGRATE.

					- Ted
