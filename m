Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675547;
	b=vJKvKMUMRNuC5B9lIRrhb955Ew7ClTBXlwxxwKrq0Nc1pivVVoHtBibUci3L2QakbN11
	 Tn7I6IZO4Lf2lFxA4Szk315DR0pSL/KoC2hpjI86ChXmJ7bXCzg+04zby3Brn/iHXgjec
	 qSrblGpX1CbM2i6p8NAnjbYVzSrIkAg7vxFvODAlzl0ZdZjS6Ty3RupIzuDbGe9yozlei
	 qtQmlslScfskAut5mXegbtOG7poi4BPdJM2Iih+iVPrUiXkdKfearhpquLnb8SuF7FBAx
	 pCF1heV1ZG6BW0AkB2Bs0CCdQusrecYip1e97XoyxENhsYnx8TvUnIHi6Tu+lCTGZFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675547;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=qxn4YhI7CBLcfWsnw/qhBLLA1v09w7Fr/9uAfa0+Fn8=;
	b=LryVo+I8vVDL33DEJIbrNX7cpxG3e/4KShN7TjvOBwNHzTtNFgEwsDdfsDdHcmd7yIzA
	 VkqbnMoVVnuCPkPAOuZdaw9RFhrNTQTuTtlZ5FOKCHi9D7k4zw4Uz7CfuHK7apFBcKdJa
	 uGScT3Y7u/mkh5ejdPVG5hWkRU2T8gy26ND/YdIipzSg+UPSuCbYVCu9PY1f7XjX+Szuu
	 H6NYny++6RgkkNWqoazlTjE9gjsagVzCcL048qN82+Zg57Y+CL2PlHkzq7bH0kLPyOOO1
	 ofEL9tuaQ9nYTkB9EyRVBf/Rd/CSz1seJAqDhTtukkHZhVpgk/ajk2sS3qwdRsrNg9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=C4qM+hsz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF00606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 13:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BF00606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=C4qM+hsz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792675545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qxn4YhI7CBLcfWsnw/qhBLLA1v09w7Fr/9uAfa0+Fn8=;
	b=C4qM+hszCcO7CsBiu/OT10DdBiutcII/6U/WK5EWm8XK3nDp7QtmDKlBzF3qeSYw7oaK1n
	IFN03ZLsdMiA7dfkNA15A6YehJhjW1qrJfYcwjdrbbv69dMAPvAK6BEfYDEk9XrhhAMcBW
	7gqjOK6/rFvZPRN1POza0hwTN11awK4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-FV9fmJxEOM-Z_GWrXzaf_A-1; Thu,
 22 Oct 2026 13:25:40 +0000
X-MC-Unique: FV9fmJxEOM-Z_GWrXzaf_A-1
X-Mimecast-MFC-AGG-ID: FV9fmJxEOM-Z_GWrXzaf_A_1792675539
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91AF51955DAC;
	Thu, 22 Oct 2026 13:25:38 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADAF41956089;
	Thu, 22 Oct 2026 13:25:36 +0000 (UTC)
Date: Thu, 22 Oct 2026 09:25:34 -0400
From: Brian Foster <bfoster@redhat.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] common/rc: pass -V 1 when probing pwrite and pread -U
Message-ID: <atoOzsNo8zUTrxVj@bfoster>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
 <20261015-dontcache-test-v1-2-6aa7583973a9@columbia.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-dontcache-test-v1-2-6aa7583973a9@columbia.edu>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 15, 2026 at 04:54:03PM -0400, Tal Zussman wrote:
> xfs_io refuses pwritev2() and preadv2() flags unless -V is given, so
> probing -U without it always fails. Pass -V 1 for -U in both the pwrite
> and pread cases.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  common/rc | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 945c9e42..a0239034 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3105,6 +3105,10 @@ _require_xfs_io_command()
>  			opts+=" -d"
>  			pwrite_opts+="-V 1 -b $write_size"
>  		fi
> +		# -U (RWF_DONTCACHE) only works with vectored I/O writes
> +		if [ "$param" == "-U" ]; then
> +			pwrite_opts+="-V 1 -b $write_size"
> +		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
>  			# try to write the minimum supported atomic write size
> @@ -3121,9 +3125,14 @@ _require_xfs_io_command()
>  		param_checked="$pwrite_opts $param"
>  		;;
>  	"pread")
> +		# -U (RWF_DONTCACHE) only works with vectored I/O reads
> +		local pread_opts=" "
> +		if [ "$param" == "-U" ]; then
> +			pread_opts+="-V 1 -b 4k"
> +		fi
>  		testio=`$XFS_IO_PROG -f -c "pwrite 0 4k" \
> -			-c "pread $param 0 4k" $testfile 2>&1`
> -		param_checked="$param"
> +			-c "pread $pread_opts $param 0 4k" $testfile 2>&1`
> +		param_checked="$pread_opts $param"
>  		;;

I find it a little odd that we auto add command related options here
even though the test still needs to know to use those options for the
commands to work correctly. But I guess there's precedent for it, so oh
well:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	"scrub"|"repair")
>  		test -z "$param" && param="probe"
> 
> -- 
> 2.39.5
> 
> 

