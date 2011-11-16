From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Difference in statvfs(2) block count with ext2 and very recent
 Linux 3.2.0 kernels
Date: Wed, 16 Nov 2011 16:43:56 +0000
Message-ID: <20111116164356.GT2626@amd.home.annexia.org>
References: <20111116095418.GA8054@amd.home.annexia.org>
 <4EC3E5CF.6030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, meyering@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab1KPQn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 11:43:57 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAGGhvMh012899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 11:43:57 -0500
Content-Disposition: inline
In-Reply-To: <4EC3E5CF.6030805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 10:33:19AM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/16/11 3:54 AM, Richard W.M. Jones wrote:
> > 
> > Hi,
> > 
> > We do some automated testing of the kernel and ext2/3/4 filesystems,
> > and noticed that the block count returned by statvfs(2) for plain
> > *ext2* filesystems has changed with the latest 3.2.0rc1 kernel.
> > 
> > This is probably just because of more accurate block accounting, but I
> > just wanted to check that it isn't a bug.
> > 
> > This posting contains the numbers and a reproducer:
> > 
> >   https://www.redhat.com/archives/libguestfs/2011-November/msg00051.html
> > 
> > Rich.
> > 
> 
> Note that it is a plain *ext2* filesystem run through the *ext4* driver,
> in Fedora,

Correct!  We're using CONFIG_EXT4_USE_FOR_EXT23=y.

> and it was tracked down to commit f975d6bcc7a698a10cc755115e27d3612dcfe322
> ext4: teach ext4_statfs() to deal with clusters if bigalloc is enabled
> according to the above post...

Well, that's what I thought looked likely.  However I didn't bisect
this, so it could be another commit to blame ...

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
