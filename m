Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4713D5256
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774877909; cv=none; b=i1cNPofjS3PbMRo1xHSnG3KSRTncTksFzuvOtKoHszApGyXZnW5wDuRAbccChEg1/WRdsJ5AQOfzgIkXGMu75z4BP+jkkI2ozfgPjZzqacCk4NZCL8IT1Px4yqzVkH8q+ZLztU9a1r+E1Xer8nBo+k2CmyXrqpPDfXdilNDCPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774877909; c=relaxed/simple;
	bh=5I3685CjXQuqK5dhrwDdVKDMDNbm/PLucafT3sV7jOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmEgsmZcX2Ib0MyfbflIHY3EaLehDw3msArBJQzKS8KP81G+7Y7tfWrghKF2PMOsrNMDKJBz/tDKqt56TME4lH3PdxmVZaCwi9ynuLdhy6HGCW7EQ6TB+bqrkWmyvDUXihRS3ebhAZb6TpOzx7M9Bmebs9lLpyvx+3XsSZXt6kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Q7rK8ICm; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Q7rK8ICm"
Received: from macsyma.thunk.org ([104.135.218.80])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62UDc0YL004731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 09:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774877883; bh=oKoVb8nuXmkEGj7x7bnWyG1ytu/H133rG6H1d3IV8Kk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Q7rK8ICm/M0dEs0535BIJaLTn8OO/msn808vNCYXkPSDGt6KuVU0ndCoouD5pgRpw
	 o6kiSv096M7XzumF2IAsf5R/xHh2QHJ73Ni65ovHS63DEhwSQpG6S3JH+hKNwwNuDI
	 P2j8OKL+1U5MGGoU6CRINdFIuKI0caeXPI146TISAtmqzMMR04zb/D+rNHzkcBgQ/R
	 FJ7hEw5uK35ny4RP+YuGi8jT/kT+eDeYFyOWL8v7Y/4PquBvjSAMeeas6nGpu11/bC
	 oWDtGm9lrTiUTfufvYzwIKlwiI6SqQgRJZiWnbbw0XwnyXZD0aulW4GQE1TxWpb+gm
	 /z7DKv+QeDFMg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 4948F60035F7; Mon, 30 Mar 2026 09:38:00 -0400 (EDT)
Date: Mon, 30 Mar 2026 09:38:00 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, axboe@kernel.dk,
        dvyukov@google.com, adilger.kernel@dilger.ca,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: [PATCH] loop: block loop reconfiguration of offset/sizelimit on
 mounted device
Message-ID: <20260330133800.GC22278@macsyma.local>
References: <20260330044334.373480-1-kartikey406@gmail.com>
 <acoQBLwdc1PqIb0m@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acoQBLwdc1PqIb0m@infradead.org>

On Sun, Mar 29, 2026 at 10:54:12PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 30, 2026 at 10:13:34AM +0530, Deepanshu Kartikey wrote:
> > LOOP_SET_STATUS{64} allows changing lo_offset and lo_sizelimit while
> > a filesystem is mounted on the loop device. This effectively mutates
> > the data visible to the mounted filesystem, which is equivalent to
> > writing directly to the block device.
> 
> Increasing the size certainly does not do that.
> 
> > Export bdev_writes_blocked() so it can be used from the loop driver.
> 
> I'm not sure exporting this is a good idea.  Besides the growing the
> device part above, if someone insist on changing the size, they could
> do this just fine with a remove block device, so prohibiting it locally
> just because we can seems odd.  And exporting a helper with obscure
> usage for a strange use case without documenting that is rarely a
> good idea.

The patch was missing the...

  #ifndef CONFIG_BLK_DEV_WRITE_MOUNTED)

... in loop.c which was in my original sketch of a patch which I sent
to Deepanshu.

The intent was to suppress Syzkaller noise.  Inherent in my assumption
was that changing either lo_offset or lo_sizelimit parameter was going
to mutate the loop device when it was mounted, which was the intent of
!CONFIG_BLK_DEV_WRITE_MOUNTED.  I also assumed that at least for now,
the only user of !CONFIG_BLK_DEV_WRITE_MOUNTED was syzkaller, since
there are file systems (in particular ext4) that are commonly in use
whose userspace utilities fundamentally assume that you can write to
the block device.  Even after we promulgate the tune2fs changes to use
the new EXT4_IOC_SET_TUNE_SB_PARAM ioctl and we can assume that it is
common use in deployed kernels, some grub operations still assume they
can modify the block device where the second-stage grub bootloader is
located.

In the long term, when ext4 can start assuming that we can suppress
writes to the block device (and we find a solution to the grub issue),
we'll probably want to have a way to suppress write access to block
devices on a per-super basis, without clearing the Kconfig 
CONFIG_BLK_DEV_WRITE_MOUNTED.   But that's a problem for another day...

Cheers,

						- Ted
