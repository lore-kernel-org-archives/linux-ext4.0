Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675528;
	b=YvUeFDiMcZuomYQZ904v9N0KLlCIBp28tNiu47dKHIKbDay1wvV7T2oWDjtWv+iWdn3V
	 Cda9Y+9qzYNX3dys741qeA8FNaLGtfxTpOydvH4boPV4Gez9Vly7jwrXcb6Uvl3LUHk0b
	 PAREBG247XL5YGvUlaN5+FRwvAoehtfeIXSQYTKTsfkmccLv7vyfqlCzeM1KtwlyBs56M
	 jVeSpf/AmaTo5I4xv4Sax4eoXze83XxYZugyIldI4f3J2fpzE4lCUv78fp58Nr+swwHMZ
	 a1x/M9/2khy0KkmZ/1bVBLad6tR/ka761q6pu6HglXuzA+sFF++xE3OFcqImp117fuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675528;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=VwnR3aer+ih7EiPvjgqZMvrZVksxK2/7XowPs1TtL9A=;
	b=2dwGeHGkTWmVNv1lkhNRMyQxWC+SQtwRHBIhYzyaqF6cmFUYhampe3qL7TjgPNpwhJLP
	 35lYvSsA8y4UlawaP4K0wkG2n/m3EKnHLBcWzf1PUMqfZqg52fd9V7PvGxCFOALFl7riP
	 AQFycLCNEC+CJMoP/k1ClYJMEpURu1oTgg6zER8cX+jP/pOXHM9Y3D56Y5ZiMRcE4vsPb
	 LdkwUS9RN650gLXK6IsNncmC13Yrg1sQVIC2NnaK6DSNC0q7qkT9g4ImNkGJ0rp97SCy/
	 uSQOp0x6lAGkE+/sDWiMJIx5JBmmIa1ZFdboCIOCNcS0A9YH9am1PyjrYuwEgAH6O7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JgLQ+xRn;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6025B606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 13:25:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6025B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JgLQ+xRn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792675527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VwnR3aer+ih7EiPvjgqZMvrZVksxK2/7XowPs1TtL9A=;
	b=JgLQ+xRnDJuTgXsnirLQjMNJ/lr+7593cvMwvMm9I+U6/nQtR9SiYr8yav+SKNlva5LFke
	QuHo8DEL75R+WRXOwemuZMaP4hEKKWbVWpN6Dis59BHJ3CdPttsvKiG4f9ndGoK8cyQE/M
	k1oMaJkj8BbXj/6Djzg7jEknluagKVs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-9ZwIcmCVPMKpqdp9TVm7ww-1; Thu,
 22 Oct 2026 13:25:23 +0000
X-MC-Unique: 9ZwIcmCVPMKpqdp9TVm7ww-1
X-Mimecast-MFC-AGG-ID: 9ZwIcmCVPMKpqdp9TVm7ww_1792675522
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 689D11955E86;
	Thu, 22 Oct 2026 13:25:21 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A70111956089;
	Thu, 22 Oct 2026 13:25:19 +0000 (UTC)
Date: Thu, 22 Oct 2026 09:25:17 -0400
From: Brian Foster <bfoster@redhat.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] common/rc: probe pread options with a real read
Message-ID: <atoOvVxdvel6-F77@bfoster>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
 <20261015-dontcache-test-v1-1-6aa7583973a9@columbia.edu>
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
In-Reply-To: <20261015-dontcache-test-v1-1-6aa7583973a9@columbia.edu>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 15, 2026 at 04:54:02PM -0400, Tal Zussman wrote:
> _require_xfs_io_command has no pread case, so a pread option falls back
> to a grep of the help text, and that only matches options that take an
> argument. A bare -U is reported as unsupported even when xfs_io has it.
> Add a pread case that does a real read with the option, like the pwrite
> case does.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/rc | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 1eccd60c..945c9e42 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3120,6 +3120,11 @@ _require_xfs_io_command()
>  		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
>  		param_checked="$pwrite_opts $param"
>  		;;
> +	"pread")
> +		testio=`$XFS_IO_PROG -f -c "pwrite 0 4k" \
> +			-c "pread $param 0 4k" $testfile 2>&1`
> +		param_checked="$param"
> +		;;
>  	"scrub"|"repair")
>  		test -z "$param" && param="probe"
>  		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`
> 
> -- 
> 2.39.5
> 
> 

