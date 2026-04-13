Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D2C3C73FB
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776084519; cv=none; b=sL+3wdycTWFeWH8Hmxy6XKoDgmDWRNbTF6yN1ZMnVf9ozhGR6/iqC5uJAMu3L3aGn8poilYjmu1nyNR2lCKelLaz2IiFY/NnMXe5A0n8d77rkAEgqDtDFRSvoXABRj147lcn7mD4TIuHpCtfC51Z7XBlxUNLdb01fQdj1D+J9YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776084519; c=relaxed/simple;
	bh=v7asg6qA7pO2JxM8JSNzirNqzT0RT3u69UBi0wGyXEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6ayqEpmIF0kBQPjGmTKBvvbBaWSF/pvefW8A1xEFWqT1GMzuw0Id0tZti3XSnWTYOwxCWof/Z9c3yruJWLUTsIzB3IFMl4zVfepHGB5SrP1zQoi/DBT8zo8f+p7LqgZRCiCLtcVIFYtPIHggk5NYq4YI1gHvIzIiz50//KMZMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Dr7NHjXJ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Dr7NHjXJ"
Received: from macsyma.thunk.org (pool-173-48-113-10.bstnma.fios.verizon.net [173.48.113.10])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63DCm4lu013301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 08:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776084487; bh=ew0N4RW/+mMo1okUz8IGgXrBvzrPN7l+s8J2ydS6XZI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Dr7NHjXJPY+Ug6d5M4eVJih7sF68tlFdq1cMBnCxIwJJkQob4ee6dd0dXgT5zcXOs
	 Aq4t9D3pjx4bp/bw7i3vf9AJdc2XGYB7eyq+0PKUaLa6ZurQunYb9bJLVHsJVoobxF
	 bOwGP6sk/x8lXvfQib94symCoyaKSJTSYQlki3v0bsLZr7HjZ9gP3rbY3B17qvwo7K
	 E6pChC1Yjfh1spZwnVOqZ4+o4sxXzEWLrHUvFzsqlknMx03hiSGq+Eh2SAeIuxlwkQ
	 nZ2numKdP/Y+6lmfv89AUJY8cqA5FZLODZlW60zdD0KdNdRTwEd6TD43h3WJ4xbT+/
	 6c/5wrg0ukgPQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id EEB1962D9DC2; Mon, 13 Apr 2026 08:47:03 -0400 (EDT)
Date: Mon, 13 Apr 2026 08:47:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Diangang Li <diangangli@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        changfengnan@bytedance.com, yizhang089@gmail.com, willy@infradead.org,
        Diangang Li <lidiangang@bytedance.com>
Subject: Re: [RFC v2 0/1] ext4: fail fast on repeated buffer_head reads after
 IO failure
Message-ID: <20260413124703.GA20496@macsyma-wired.lan>
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260413062500.1380307-1-diangangli@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413062500.1380307-1-diangangli@gmail.com>

On Mon, Apr 13, 2026 at 02:24:59PM +0800, Diangang Li wrote:
> From: Diangang Li <lidiangang@bytedance.com>
> 
> A production system reported hung tasks blocked for 300s+ in ext4
> buffer_head paths....
> 
>   [Tue Mar 24 14:16:24 2026] blk_update_request: I/O error, dev sdi,
>       sector 10704150288 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>   [Tue Mar 24 14:16:25 2026] blk_update_request: I/O error, dev sdi,
>       sector 10704488160 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>   [Tue Mar 24 14:16:26 2026] blk_update_request: I/O error, dev sdi,
>       sector 10704382912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0

I wonder whether the ext4 layer is the right place to be handle this
sort of issue.  For example, it could be handled by having a subsystem
scanning dmesg (or by wiring up notifications so block device errors
get sent to a userspace daemon), and when certain criteria is met, the
machine is automatically sent to hardware operations to run
diagnostics and (most likey) replace the failing disk.

It could also be handled in the driver or SCSI layer so the "fail
fast" semantics are handled there, so that it supports all file
systems, not just ext4.  The SCSI layer also has more information
about the type of error; you might want to handle things like media
errors differently from Fibre Channel or iSCSI timeouts (which might
be something where "fast fast" is not appropriate).

By the time the error gets propagated up to the buffer head, we lose a
lot of detail about why the error took place.  Also, in the long term
we will hopefully be moving away from using buffer cache.

   		     	    	      	    - Ted
