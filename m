From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Use of resize2fs for enabling 64-bit inodes
Date: Fri, 17 Apr 2015 11:58:49 -0700
Message-ID: <20150417185849.GD11592@birch.djwong.org>
References: <20150417161809.GA27500@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27154 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbbDQS6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2015 14:58:55 -0400
Content-Disposition: inline
In-Reply-To: <20150417161809.GA27500@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 17, 2015 at 06:18:09PM +0200, Jan Kara wrote:
>   Hello,
> 
>   I've noticed that you've implemented enabling 64-bit mode of a filesystem
> in resize2fs. That is quite logical from the implementation point of view
> however IMHO it doesn't make too much sense from user point of view.  I'd

I agree it's awkward; right now there's a bandaid that tune2fs -O 64bit will
tell you how to run resize2fs...

> rather expect that functionality to be in tune2fs. So shouldn't we rather
> abstract the code into a separate library that would be linked to both
> resize2fs and tune2fs? Alternatively we could just make tune2fs call
> resize2fs with appropriate options.

...but I've wondered myself why we have two utilities for transforming ext4
filesystems.  A library would probably be cleaner, but it wouldn't be too
hard to change existing tune2fs functionality to run (instead of telling
the user how to run) resize2fs for 64bit conversion.

I guess one could combine the two into a frankentool that uses argv[0] to
figure out which half of itself to run, with the tune2fs side being able
to call into the resize2fs side.  But maybe it's time for the 'high level e2fs
library' that Ted has been talking about for a while?

> I'm asking because I'm now looking into implementing increasing number of
> reserved inodes. For that we may need to move some inodes and it would be
> natural to use code from resize2fs for that. But adding that as an option
> to resize2fs is just unintuitive from user point of view so I'd like to
> have some concensus on how we do this... Darrick, Ted, any opinion?

What do you think of the thread "e2fsprogs: reserve more special inodes" from a
month or so ago?

--D

> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
