From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Thu, 20 Sep 2007 14:42:38 -0600
Message-ID: <20070920204238.GK32520@schatzie.adilger.int>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:56513 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXITUmN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 16:42:13 -0400
Content-Disposition: inline
In-Reply-To: <46F2D678.4060203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 20, 2007  15:22 -0500, Eric Sandeen wrote:
> I'd do this, my rpm-fu is still reasonably strong, though - I'm curious,
> is there a compelling reason to split out just libcom-err?  what about
> libuuid?  libblkid?  e2fsprogs is a bit of a grab bag of things.  What's
> the rationale for the split?

Well, I think its just "e2fsprogs needs (and largely developed) these things
and Ted doesn't want external package dependencies".  There isn't a strong
reason to have them in a single package, especially as you say there are
more external packages that begin to depend on them, and e2fsprogs
(the libext2fs, e2fsck, etc. part) shouldn't necessarily be a "required"
package.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
