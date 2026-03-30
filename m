Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0870F3806DD
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 19:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774897277; cv=none; b=IMSoDvkEsRxEB4WB6xvHAIFCJ7qeEfFWFEd1dk3Jk5nT81iyvt3VKotDB2VF7TVE2iRUJYsNkiKWtwNz/UfzzPhplJsJbmeRFOapyIFu80jtI/AJLjWxM8uXw/EBXZbPK44zp8EF39WOACrJH7aI8xurEw5X2GYFi00rIocWg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774897277; c=relaxed/simple;
	bh=HOevPGuZTBls5+xHraEmWH0kFBXkG1OWp/CawLOgShs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqJ5JVlskn9+2uT6SDrG+fa9vFu+5OCrHUIbgub7egxCeWn5eY8phsbIVizjR7Y9mpaw7lHlI1G+qeIONrjFDCqHcFdQZYtbsGdPkUA3HmtUZJ6MmHwhgx16vpdDXVa6CcNMxqnSdR5vEVJNKw4NLNkknyyvs9EjLf3mvp+cO+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=gE216fKt; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="gE216fKt"
Received: from macsyma.thunk.org ([104.135.218.82])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62UJ0reQ001670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Mar 2026 15:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774897256; bh=nZlcZRdhA0AHs0rqFoHFJpsMob20gEp4e9qaMZOHKyY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gE216fKt3BOv0ndA512g5QunMJ/5Legzcz0v3kTJxxfjY0/HDOspx9TsEWtXhsWaS
	 GaOp5J/GN1/kwDNTdCaDeht4ybWBO04lhiOUtFYDUqEvva6Ahut/fiS/cUUYhp8A3/
	 f1CoMuIQLyoHG51+Ch88VQuhyx2W3ngVPj7PWgItqdennGWa7goZtJ+OyBGOE+oa8W
	 ex99Whl7n2h52jY0g+pvXCB666J/xAsuuERra2A1j9AkZ83NnF+XtltNpdZ2u5a3UL
	 4BH0P5DrKmB2hWauKFR7D629uqmPa10BPTcm3DEJfSC8OkMndz2bOetiqXyJ0Br52G
	 aahoeUeYKbOqA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B57BB600CEF6; Mon, 30 Mar 2026 15:00:52 -0400 (EDT)
Date: Mon, 30 Mar 2026 15:00:52 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dvyukov@google.com,
        adilger.kernel@dilger.ca, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: Re: [PATCH] loop: block loop reconfiguration of offset/sizelimit on
 mounted device
Message-ID: <20260330190052.GA50033@macsyma.local>
References: <20260330044334.373480-1-kartikey406@gmail.com>
 <acoQBLwdc1PqIb0m@infradead.org>
 <20260330133800.GC22278@macsyma.local>
 <CADhLXY6Cu+O_jeL9xxORtLg-LU6pdBxFb29yhS=d2rTtgbA2tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADhLXY6Cu+O_jeL9xxORtLg-LU6pdBxFb29yhS=d2rTtgbA2tw@mail.gmail.com>

On Mon, Mar 30, 2026 at 08:03:55PM +0530, Deepanshu Kartikey wrote:
> 
> The check would be:
> 
> #ifndef CONFIG_BLK_DEV_WRITE_MOUNTED
> if ((lo->lo_offset != info->lo_offset ||
>      lo->lo_sizelimit != info->lo_sizelimit) &&
>     lo->lo_device->bd_writers < 0) {
> err = -EBUSY;
> goto out_unlock;
> }
> #endif

Can you please move bdev_writes_blocked() into
include/linux/blk_types.h as an inline function as Christoph
suggested?

The reason for that is that "bdev_writers < 0" is an implementation
detail and it might change in the future, and then loop driver might
break unexpectedly.  Using bdev_writes_blocked() is also much clearer
from a code readability perspective.

> Regarding Christoph's point about increasing lo_sizelimit being
> safe - should I narrow the check to only block shrinking and
> offset changes?

Yes, I think we should allow the loop device to grow, since that's
harmless and there are some legitimate use cases when people might
want to do this and then trigger an online resize so the file system
grows to use the added space.

						- Ted
