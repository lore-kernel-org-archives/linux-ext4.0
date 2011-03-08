From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfstests: add fallocate calls to fsx
Date: Tue, 08 Mar 2011 14:00:47 -0600
Message-ID: <1299614447.2716.32.camel@doink>
References: <4D6BDC2A.4020308@redhat.com>
Reply-To: aelder@sgi.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:48084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755447Ab1CHUAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2011 15:00:48 -0500
In-Reply-To: <4D6BDC2A.4020308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2011-02-28 at 11:32 -0600, Eric Sandeen wrote:
> (Sending one more time, hoping for a real reviewed-by) :)
> 
> Add random runtime fallocate calls to fsx (vs. the existing
> preallocate file at start of run).

Whoops.  I'm not sure what keyboard shortcut I hit
on that last one but I managed to fire off that
message before I'd actually written it.  Here's another
try.

Bottom line is, this looks good to me, but I do have
a few things for you to consider before you commit it.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

. . .

> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 1167d72..b95431e 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c


> @@ -105,6 +109,11 @@ long	numops = -1;			/* -N flag */
>  int	randomoplen = 1;		/* -O flag disables it */
>  int	seed = 1;			/* -S flag */
>  int     mapped_writes = 1;              /* -W flag disables */
> +#ifdef FALLOCATE
> +int     fallocate_calls = 1;            /* -F flag disables */
> +#else
> +int     fallocate_calls = 0;            /* -F flag disables */
> +#endif

I think you should just skip the conditional initialization
here and just assign it the value 1.  (I point out below
what I suggest you do instead.)

>  int 	mapped_reads = 1;		/* -R flag disables it */
>  int	fsxgoodfd = 0;
>  int	o_direct;			/* -Z */

. . .

> @@ -845,22 +921,33 @@ test(void)
>  		prt("%lu...\n", testcalls);
>  
>  	/*
> -	 * READ:	op = 0
> -	 * WRITE:	op = 1
> -	 * MAPREAD:     op = 2
> -	 * TRUNCATE:	op = 3
> -	 * MAPWRITE:    op = 3 or 4
> +	 *                 lite  !lite
> +	 * READ:	op = 0	   0
> +	 * WRITE:	op = 1     1
> +	 * MAPREAD:     op = 2     2
> +	 * TRUNCATE:	op = -     3
> +	 * MAPWRITE:    op = 3     4
> +	 * FALLOCATE:   op = -     5
>  	 */
>  	if (lite ? 0 : op == 3 && (style & 1) == 0) /* vanilla truncate? */
>  		dotruncate(random() % maxfilelen);
>  	else {
>  		if (randomoplen)
>  			size = random() % (maxoplen+1);
> +
> +		/* truncate */
>  		if (lite ? 0 : op == 3)

This is not huge, but I personally would rather see these
comments *inside* the block they're describing.  So the
"truncate" comment would go here, ...

>  			dotruncate(size);
>  		else {
>  			offset = random();
> -			if (op == 1 || op == (lite ? 3 : 4)) {
> +			/* fallocate */
> +			if (op == 5) {

...the "fallocate" comment would go here...
> +				offset %= maxfilelen;
> +				if (offset + size > maxfilelen)
> +					size = maxfilelen - offset;
> +				dofallocate(offset, size);
> +			/* write / mapwrite */
> +			} else if (op == 1 || op == (lite ? 3 : 4)) {

...the "write / mapwrite" comment would go here...

>  				offset %= maxfilelen;
>  				if (offset + size > maxfilelen)
>  					size = maxfilelen - offset;
> @@ -868,6 +955,7 @@ test(void)
>  					domapwrite(offset, size);
>  				else
>  					dowrite(offset, size);
> +			/* read / mapread */
>  			} else {

...and the "read / mapread" comment would go here.

>  				if (file_size)
>  					offset %= file_size;

. . .

> @@ -1331,6 +1425,16 @@ main(int argc, char **argv)
>  	} else 
>  		check_trunc_hack();
>  
> +#ifdef FALLOCATE
> +	if (!lite && fallocate_calls) {
> +		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
> +			warn("main: filesystem does not support fallocate, disabling");
> +			fallocate_calls = 0;
> +		} else
> +			ftruncate(fd, 0);
> +	}

Add this here (rather than the conditional initialization
on top):

#else /* ! FALLOCATE */
	fallocate_calls = 0;

> +#endif
> +
>  	while (numops == -1 || numops--)
>  		test();
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



