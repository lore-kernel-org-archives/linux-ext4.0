From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sat, 26 Dec 2009 11:06:38 -0800
Message-ID: <4B365EBE.5050804@nerdbynature.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de> <4B36333B.3030600@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Larry McVoy <lm@bitmover.com>, tytso@mit.edu,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZLZTHV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Dec 2009 14:07:21 -0500
In-Reply-To: <4B36333B.3030600@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26.12.09 08:00, jim owens wrote:
>> I was using "sync" to make sure that the data "should" be on the disks 
> 
> Good, but not good enough for many tests... info sync
[...]
>        On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
>        writing;  it  can  actually take a short time before all the blocks are
>        finally written.

Noted, many times already. That's why I wrote "should be" - but in this
special scenario (filesystem speed tests) I don't care for file
integrity: if I pull the plug after "sync" and some data didn't make it
to the disks, I'll only look if the testscript got all the timestamps
and move on to the next test. I'm not testing for "filesystem integrity
after someone pulls the plug" here. And remember, I'm doing "sync" for
all the filesystems tested, so the comparison still stands.

Christian.
