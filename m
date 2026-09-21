Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097CB3537E5;
	Mon, 21 Sep 2026 05:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789968453; cv=none; b=Sa6AZg6IIAWGUSK+3oCgEbJQMxD+L8I0uiqNvBNqQSAM9o+uYng1fxfFimyo4Ug+k/o6jjl4tvveqiPbajS5nwmnt5iuT+c7kiUGOVVYx7j7EghOxBMtzXvccl1CfeWXFKTOlS415wlK22mwaZSQKV76jvGX53AHBX9gN9m0n6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789968453; c=relaxed/simple;
	bh=3rw5XDzLO95BT3ztdS/2a1sEBq3g9JIFEagCJUGTigo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ip5Io+5vAzyi+92d9PaLna36LeTtbsI1yFhIBb/BfXfhhYmWHrAWpWNAglp0LK6IZcg+O7WSqaGjQvbkBFasNS1sFceXYihQeIfMWfJTK5aUc/Mb5RC6m+sWLOj+GWB7LK6L3jEnPvDee57yvvrTBQvCppkuDJATiU+Rt1wbDQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgmAL00E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgmAL00E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9DE131F00893;
	Mon, 21 Sep 2026 05:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789968439;
	bh=xFMEKYbRwNC7H91OdSH+p2qEtamOLU+cDxpa6fNv0sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jgmAL00EFcIJ51rrNVmSDisE4IxqREdir669lzXT+7Q/dL82nILSXr5cAZLlLpE0e
	 es73SS3UgbFvDYxHpdNwdcvRrJ3pYcasWSV2torB741zyjXrPF0Wo5zg/dTYub4HUU
	 Kr4ONIHNlQCXynzMDsxliqWVDaIiGBpjELn7A7Re9UjF5EBhN9P5SNjA9AJwMQyjrl
	 SmdgfUaHxb0UhmTXoDhCeLZT8qsU9+YjnFaVx4gXxGoCXTmCNuyrk1jrHl/Q2riOG6
	 7URn1t/ITEB0o+o2KK5G6VuXxig6p9hD/sxQBh3QX+I5jEcPfxld9fzdGYZEBRUHrz
	 AO1C07LZoolvw==
Date: Sun, 20 Sep 2026 22:27:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, dgc@kernel.org
Subject: Re: [PATCH] generic/492: bypass the blkid cache when probing the
 label
Message-ID: <20260921052719.GB6253@frogsfrogsfrogs>
References: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920094137.2749428-1-libaokun@linux.alibaba.com>

On Sun, Sep 20, 2026 at 05:41:37PM +0800, Baokun Li wrote:
> blkid may serve a stale label from its cache instead of probing the
> device, so the label just set via xfs_io can be missed and the output
> mismatch is non-deterministic.
> 
> Pass "-c /dev/null" so that blkid always probes the on-disk superblock
> directly.  Unlike the low-level probing mode (-p), which requires
> util-linux 2.16 or later, this is also supported by the legacy blkid
> shipped with e2fsprogs.
> 
> Fixes: c3c9630968a6 ("generic: test online label ioctl")
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Seems fine to me; I guess blkid could be racing with whatever updates
the cache...udev?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/generic/492 | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/492 b/tests/generic/492
> index 51a46b510453..0b4f69b80f17 100755
> --- a/tests/generic/492
> +++ b/tests/generic/492
> @@ -28,14 +28,15 @@ $XFS_IO_PROG -c "label -c" $SCRATCH_MNT
>  $XFS_IO_PROG -c "label" $SCRATCH_MNT
>  
>  # And that userspace can see it now, while mounted
> -# NB: some blkid has trailing whitespace, filter it out here
> +# NB: bypass the blkid cache which may hold a stale label, and filter
> +# out the trailing whitespace some blkid versions emit
>  $XFS_IO_PROG -c "label -s label.$seq" $SCRATCH_MNT
>  $XFS_IO_PROG -c "label" $SCRATCH_MNT
> -blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
> +blkid -c /dev/null -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
>  
>  # And that the it is still there when it's unmounted
>  _scratch_unmount
> -blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
> +blkid -c /dev/null -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
>  
>  # And that it persists after a remount
>  _scratch_mount
> -- 
> 2.43.7
> 
> 
