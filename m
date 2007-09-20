From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Wed, 19 Sep 2007 23:09:23 -0600
Message-ID: <20070920050923.GX32520@schatzie.adilger.int>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41376 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXITFI5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 01:08:57 -0400
Content-Disposition: inline
In-Reply-To: <46F1CFC0.3070801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 19, 2007  20:41 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > It isn't possible to build an e2fsprogs via "make rpm" on SuSE and have it
> > install cleanly, because they split out some of the libraries into separate
> > packages.
> > 
> > We've got the current patch to the .spec file, but I'm open to discussion
> > if it is more desirable to change the .spec to continue to build separate
> > RPMs (though that is more of a distribution hassle and might need major
> > changes in the .spec file).
> 
> FWIW, I also have an RFE assigned to me for RHEL/Fedora to split up our
> e2fsprogs packages for libcom_err and libuuid... since many
> non-filesystem things now require them.   So, this is sort of going in
> the opposite direction.  :)
> 
> Any idea how many distros already split it out?

I know Debian-based distros have done this for ages...

I'd also welcome someone with rpm-fu split it into separate packages.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
