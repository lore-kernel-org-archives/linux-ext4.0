From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: xfstests failures w/ metadata_csum
Date: Mon, 1 Dec 2014 17:05:34 -0500
Message-ID: <20141201220534.GA4619@wallace>
References: <20141201202045.GR10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33136 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaLAWFh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2014 17:05:37 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so8079519qae.27
        for <linux-ext4@vger.kernel.org>; Mon, 01 Dec 2014 14:05:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20141201202045.GR10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Darrick J. Wong <darrick.wong@oracle.com>:
> Hi Eric,
> 
> Could you remind me which xfstests are failing in 3.18-rc3+ with metadata_csum
> enabled?  I think you said generic/034, generic/321, and generic/322, but were
> there more?

Hi Darrick:

The other failing test is generic/325 - you've got the others right.  Note that
I may be an xfstests version ahead of xfstests-bld, so depending on what you're
running, you may not see all of those.  (Gonna stick closer to xfstests-bld
from now on.)  The failures are the same in the inline data test scenario.

Thanks for looking at this!

Eric

> 
> AFAICT the ext4 mount fails because it can't load the journal, and the journal
> can't replay because jbd2_descr_block_csum_verify() fails; the 034 test appears
> to drop all the writes related to the umount.  recovery.c doesn't say anything
> when the journal descriptor block fails csum verification, though it should.
> Not sure why we end up with corrupt-looking descriptor blocks.
> 
> The reason why this appears in -rc3 is because that's when we added the patch
> that forces journal_checksum on whenever metadata_csum is on, and I guess
> few people were testing journal_checksum with xfstests before that.
> 
> --D
