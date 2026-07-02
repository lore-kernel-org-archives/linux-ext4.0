Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B015423909C;
	Thu,  2 Jul 2026 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001573; cv=none; b=ORziPh5eqa5PV0F+RtqTxSu1WP7UbRKbNNHRoSihs43t0I3MD5+SF0QuqeRrmaDRJSxA+Hd5Bh0fOKNiYJg46YseoqOtdolaUPnwIduCQRiMrh4GZjHlNhHWunXkBEiFvm4JZjVIg3vxozAhFg1VMh7eRB1sOAbejjS9t4z6DeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001573; c=relaxed/simple;
	bh=tvTsZDjf2fhGySByE9ROAH4UK4iLC2jPha0ViLQAwTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTdyRQ5elRCES04QedDYLVta7IznLq98dvXND7J6nsmYejsWGdboAhTa/gwyV1XFSVjsZFTCIRMqMAXfxiWktnPqTBUgcWCaaX5pjyqJfz0C3/egUP4YZl4km+vTNb/RRw2G7lFzgEGU/2JZSo8nH3P12I85l6CMVC8zYNdw7Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTKZULeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTKZULeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D9A1F000E9;
	Thu,  2 Jul 2026 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783001572;
	bh=iqz5Du5IDsnX8TpY2PI/QH6BNGk5SwNhXkvWeledBas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VTKZULeUnvQ9hRBHNV0ZiTFtGinV7y70p0ps0znmHRtzpFmSUNz2rx1WAVnhX97Sk
	 dzqU/65/i8upUcG0m4R6v5eJ19mUyOF/5nJ6meKuInAy6ldc/qJR2M1rkLSaOFnspU
	 0fuw7g5YOv+7OzK6V1t5JqpIk8j2BLP2IQ2Arpc4=
Date: Thu, 2 Jul 2026 16:13:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yoann Congal <yoann.congal@smile.fr>
Cc: stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Subject: Re: [RESEND] "ext4: get rid of ppath in get_ext_path()" 6.6.y
 backport request
Message-ID: <2026070251-amnesty-jazz-f40f@gregkh>
References: <DJH7FQUH9KQI.N8NISCQILPH8@smile.fr>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJH7FQUH9KQI.N8NISCQILPH8@smile.fr>

On Wed, Jun 24, 2026 at 12:24:21PM +0200, Yoann Congal wrote:
> Hello,
> 
> (Resent with developers/maintainers of the patch in CC)
> 
> I'd like to request the backport of
> 6b854d552711 ("ext4: get rid of ppath in get_ext_path()")
> on the 6.6.y branch.

Please submit it if you wish to see it applied.

thanks,

greg k-h
