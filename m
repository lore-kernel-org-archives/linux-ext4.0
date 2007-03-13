From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 13 Mar 2007 03:01:34 -0400
Message-ID: <20070313070134.GK5266@schatzie.adilger.int>
References: <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070306203952.471218df.akpm@linux-foundation.org> <20070307170955.GA4252@skl-net.de> <20070307114525.08265c33.akpm@linux-foundation.org> <1173297911.3769.3.camel@dyn9047017103.beaverton.ibm.com> <45F57034.2020402@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
	Andre Noll <maan@systemlinux.org>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57017 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbXCMHBg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2007 03:01:36 -0400
Content-Disposition: inline
In-Reply-To: <45F57034.2020402@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 12, 2007  16:22 +0100, Valerie Clement wrote:
> Mingming Cao wrote:
> >IBM has done some testing (dbench, fsstress, fsx, tiobench, iozone etc)
> >on 10TB ext3, I think RedHat and BULL have done similar test on >8TB
> >ext3 too.
> 
> Is there not a problem of backward-compatibility with old kernels?
> Doesn't we need to handle a new INCOMPAT flag in e2fsprogs and kernel
> before allowing ext3 filesystems greater than 8T?

No, it really depends on the kernel.  There were some bugs that caused
problems with > 8TB because of signed 32-bit int problems, so it isn't
really recommended to use > 8TB unless you know this is fixed in your
kernel (and any older kernel you might have to downgrade to).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
