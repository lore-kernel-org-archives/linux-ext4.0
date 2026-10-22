Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675569;
	b=Js3MSh12jx2kUHl9z7N5+ZLEJHbRT9LAwaxYZMaXuq7Xm0mqnpB0S0jc7AOX+Xy/0FeL
	 9mrVQaCeTHJ9G2NwMGo/qCQjSa6MqIZixUDM8MIBRey1CeOe8CzvobXpyN/SFbZpsro7w
	 XzUCaVh74jfpxd6WUDlmF+SKjx5FNhPv2lDCdMN0e7xGA313NGucwoWyNuVirpHIksABx
	 bWpQND2nWJrqRdEiOfsdPp7ljycFhOLV18rQYoCOsYLckK0AfZ5cBYJEBJ6GhHaU27LhZ
	 6yNTmEYctVjo9CTWhbiYxJ1vU0u74OwnM9R9JYuvkdetCs16p1v1FE8absqfgBjtXJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675569;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=T8lyr8kdMdWUxPK0y3IxLAHzFnJ3weOFR/RvDwkfPew=;
	b=bJ32EBHvfvskZfd+dQs5nkziN+vy9B3548Hxr7CsXpTSvCAq9Is97AC+3PxP/2XKokaz
	 n0ObFcDMAzE7ucfJ+8/o/ygZmINlwKCqql65md0P0/uIjPP2kIRzaQUxx6RImulry7AIF
	 7bAqxW6ThoKxnxrjcgB156zuIDB4ui8FroZk9up3mrpkYDS1M1uKoZkO3Em5yBOLrpe5u
	 D2+vLLeZgpSRcib9DCBcbgwMmG/6s1R8uuTxn+8SWwiFQ8DvI05LF0mxWdL6a03k86xeI
	 lMYc/TGJEFEqbqVSxN6yTBxLyDCDLWdzvxn6GqYEoLxQh4QrxXy/VDACcDHGk2tdS2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SHOsKFul;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC64606A322
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 13:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDC64606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SHOsKFul
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792675568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T8lyr8kdMdWUxPK0y3IxLAHzFnJ3weOFR/RvDwkfPew=;
	b=SHOsKFulj7IwM2HXSef1I2Ka/ZV74LjsQq6MGlcpJMX31XAUhRtQPtGAYQOCy1jS1azcJo
	8Crdq4PchyZoLvfPdWD9hMmvBsz5HwcCwUmYDXwSNdGRAIwNRJ+xxnO7rik75k27mL1MKu
	lspWxSkINadcioQeytqaApbTA4M9MDI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-tTm7Z_I7MFKIOsBIrl20pg-1; Thu,
 22 Oct 2026 09:26:04 -0400
X-MC-Unique: tTm7Z_I7MFKIOsBIrl20pg-1
X-Mimecast-MFC-AGG-ID: tTm7Z_I7MFKIOsBIrl20pg_1792675563
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDA651955D9E;
	Thu, 22 Oct 2026 13:26:02 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C2881956089;
	Thu, 22 Oct 2026 13:26:01 +0000 (UTC)
Date: Thu, 22 Oct 2026 09:25:59 -0400
From: Brian Foster <bfoster@redhat.com>
To: Tal Zussman <tz2294@columbia.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] generic/810: check that RWF_DONTCACHE I/O drops its
 folios
Message-ID: <atoO5y_YzaYWmoc-@bfoster>
References: <20261015-dontcache-test-v1-0-6aa7583973a9@columbia.edu>
 <20261015-dontcache-test-v1-3-6aa7583973a9@columbia.edu>
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
In-Reply-To: <20261015-dontcache-test-v1-3-6aa7583973a9@columbia.edu>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Oct 15, 2026 at 04:54:04PM -0400, Tal Zussman wrote:
> A dontcache write drops its folios from the page cache once writeback
> completes, and a dontcache read drops them once the read completes.
> 
> Test this by writing and reading a 1M file with and without
> RWF_DONTCACHE and checking with mincore how much of it is cached
> afterwards: all of it for plain I/O, none of it for dontcache I/O.
> 
> The overwrite is a separate case because the drop is skipped when
> writeback completes in interrupt context, which is what happens on ext4
> without commit "ext4: complete dropbehind writeback in task context"
> [1].
> 
> Link: https://lore.kernel.org/linux-ext4/20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu/ [1]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  tests/generic/810     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/810.out | 11 +++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/tests/generic/810 b/tests/generic/810
> new file mode 100755
> index 00000000..9022c26a
> --- /dev/null
> +++ b/tests/generic/810
> @@ -0,0 +1,82 @@
...
> +# Count the bytes of the file that are in the page cache.
> +cached_bytes()
> +{
> +	local pages
> +
> +	pages=$($XFS_IO_PROG -c "mmap -r 0 $size" -c "mincore" $file | \
> +		awk '{ n += $4 } END { print n + 0 }')
> +	echo $((pages * pagesize))
> +}
> +
> +report_cached()
> +{
> +	echo "$(cached_bytes) of $size bytes cached"
> +}
> +
> +# Dontcache writeback drops a folio right after it clears the writeback flag,
> +# so a check immediately after fsync returns can run a moment too early. Give
> +# the drop a little time before reporting.
> +report_cached_after_writeback()
> +{
> +	local i
> +
> +	for ((i = 0; i < 50; i++)); do
> +		[ "$(cached_bytes)" -eq 0 ] && break
> +		sleep 0.1
> +	done
> +	report_cached
> +}

So if I understand this right, the fsync completion isn't technically
sufficient to prevent the don't cache drops from racing with the mincore
check, right?

If so, then we give the system up to 5 seconds or so to report the don't
cache results. That seems reasonable to me, but I find the interface a
little unclear since it seems not universally used for write(back)
cases.

IOW (and I realize this is a wonky example), suppose don't cache breaks
in some way where it starts to apply to cases where it shouldn't.. do we
want to try and test for that?

This is kind of a nit and I'm not opposed to the test as is, so FWIW:

Reviewed-by: Brian Foster <bfoster@redhat.com>

But I do wonder whether this might be a little more robust if we just
gave the writeback case some unconditional settle time before checking
the result. The caveat I suppose is reclaim could still technically
occur at any time and cause false results either way, so *shrug*.

An idea that comes to mind could be to perhaps combine these two
report_cached helpers into one with an optional delay parameter. If not
specified then return the immediate result. If a delay is specified then
still check the initial result, but wait up to $delay seconds for the
result to change. Then maybe the don't cache case could use a little
more aggressive of a delay, but we could still have a short one for the
normal cached case(s). Hm?

Brian

> +
> +echo "plain write"
> +$XFS_IO_PROG -f -c "pwrite -q 0 $size" -c fsync $file
> +report_cached
> +
> +echo "dontcache write to a new file"
> +rm -f $file
> +$XFS_IO_PROG -f -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
> +report_cached_after_writeback
> +
> +# Start each of the remaining cases from an empty page cache.
> +echo "dontcache overwrite"
> +_scratch_cycle_mount
> +$XFS_IO_PROG -c "pwrite -q -U -V 1 -b $size 0 $size" -c fsync $file
> +report_cached_after_writeback
> +
> +echo "dontcache read"
> +_scratch_cycle_mount
> +$XFS_IO_PROG -c "pread -q -U -V 1 -b $size 0 $size" $file
> +report_cached
> +
> +echo "plain read"
> +_scratch_cycle_mount
> +$XFS_IO_PROG -c "pread -q 0 $size" $file
> +report_cached
> +
> +_scratch_unmount
> +_exit 0
> diff --git a/tests/generic/810.out b/tests/generic/810.out
> new file mode 100644
> index 00000000..cb6c3f2a
> --- /dev/null
> +++ b/tests/generic/810.out
> @@ -0,0 +1,11 @@
> +QA output created by 810
> +plain write
> +1048576 of 1048576 bytes cached
> +dontcache write to a new file
> +0 of 1048576 bytes cached
> +dontcache overwrite
> +0 of 1048576 bytes cached
> +dontcache read
> +0 of 1048576 bytes cached
> +plain read
> +1048576 of 1048576 bytes cached
> 
> -- 
> 2.39.5
> 
> 

