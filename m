From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfstests: Add fallocate zero range operation to
 fsstress
Date: Wed, 26 Feb 2014 07:15:40 +1100
Message-ID: <20140225201539.GZ13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50848 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbaBYUPn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Feb 2014 15:15:43 -0500
Content-Disposition: inline
In-Reply-To: <1393355728-12056-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 25, 2014 at 08:15:24PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

commit message?

> @@ -2561,6 +2567,62 @@ punch_f(int opno, long r)
>  }
>  
>  void
> +zero_f(int opno, long r)
> +{
> +#ifdef FALLOCATE
> +	int		e;
> +	pathname_t	f;
> +	int		fd;
> +	__int64_t	lr;
> +	off64_t		off;
> +	off64_t		len;
> +	struct stat64	stb;
> +	int		v;
> +	char		st[1024];

[snip]

We now have 3 copies of this fallocate code, the only difference
between the copies being the mode:

> +	int mode = FALLOC_FL_ZERO_RANGE;

passed into the fallocate function. Please factor.

> +
> +	init_pathname(&f);
> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
> +		if (v)
> +			printf("%d/%d: zero range - no filename\n", procid, opno);
> +		free_pathname(&f);
> +		return;
> +	}
> +	fd = open_path(&f, O_RDWR);
> +	e = fd < 0 ? errno : 0;

while you are there, get rid of the ternary operations and just use

	if (fd < 0)
		e = errno;

> +	check_cwd();

This can go after we've checked for an error on open, which avoids
needing to save the errno....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
