From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: shared/289 failures on metadata_csum, e2fsprogs master branch
Date: Tue, 11 Mar 2014 17:20:48 -0400
Message-ID: <20140311212048.GB2274@wallace>
References: <20140311193819.GA2274@wallace>
 <20140311204549.GB31864@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:56315 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaCKVU4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 17:20:56 -0400
Received: by mail-qa0-f50.google.com with SMTP id o15so9003009qap.37
        for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 14:20:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140311204549.GB31864@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Darrick J. Wong <darrick.wong@oracle.com>:
> On Tue, Mar 11, 2014 at 03:38:19PM -0400, Eric Whitney wrote:
> > Xfstest shared/289 fails when run on an ext4 test filesystem created with
> > the metadata_csum and 64bit options and using executables from the latest
> > e2fsprogs master branch (46d2a26683).  I've seen the problem on kernel
> > versions from 3.14-rc1 through 3.14-rc6, but I think this is an e2fsprogs
> > regression rather than a kernel problem.
> > 
> > The failing portion of shared/289 can be boiled down to:
> > 
> > mkfs.ext4 -O metadata_csum,64bit /dev/vdc
> > dumpe2fs -h /dev/vdc 2>/dev/null | awk '/Free blocks:/{print $3}'
> > 
> > The problem (in my test config) is that the reported free block value is
> > 184684916231 (much larger than my test device) where the reported block
> > count is 1382400 (much saner).
> > 
> > The bug appears to have been introduced between two merges of the maint
> > branch: 72958b6670 (good - 10 Jan) and f0996c12d5 (bad - 30 Jan).  Some
> > weeks ago, I thought I'd bisected the problem to a specific patch
> > (8e44eb64bb - libext2fs: mark group data blocks when loading block bitmap),
> > which seemed like a plausible candidate.  However, I find I can't
> > reproduce the bisection now, as e2fsprogs doesn't want to support the
> > metadata_csum, 64bit options during bisection in the master branch (that'll
> > teach me for not mentioning this earlier... :-) ).
> 
> This is fixed by patch #17 ("libext2fs: fix 64bit overflow in
> ext2fs_block_alloc_stats_range") in the patchbomb I sent out earlier today.
> 

Works for me.

Thanks!
Eric


> --D
> > 
> > Thanks,
> > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
