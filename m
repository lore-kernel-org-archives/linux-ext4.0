From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Fsck repair takes very long for 1,761 inodes containing
 multiply-claimed blocks on ext4
Date: Wed, 15 Apr 2015 12:06:14 -0700
Message-ID: <20150415190614.GA11592@birch.djwong.org>
References: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akos Csete <akos.csete@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47915 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbDOTGQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2015 15:06:16 -0400
Content-Disposition: inline
In-Reply-To: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2015 at 11:18:18AM -0400, Akos Csete wrote:
> I ran into a very long execution time, approaching 48 hours, with
> e2fsck 1.42.9 when running e2fsck -fyv on a 7.8TB volume after
> fsck.ext4 -nf found 1761 inodes containing multiply-claimed blocks.
> I've been tailing the e2fsck output combined with a timestamp and
> found progress is extremely slow.
> Is this slow processing expected? I checked Ted's response to a 2009
> posting for ext3 with a similar issue where he recommended selectively
> wiping inodes with debugfs clri then restoring files as needed. Are
> there any other options for ext4, perhaps other/faster repair
> alternatives?

Unfortunately, the multiple-blocks cleaner runs one block at a time and is
quite slow.  1.42.12 might improve things somewhat since I cleaned out some of
the stranger things it would do, but it's still not fast.

(Some day in the future maybe we'll support reflink in which case this whole
part of fsck can go away.)

--D

> 
> Thanks,
> Akos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
