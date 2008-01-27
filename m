From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] UPDATED: ignore "safe" flag differences when
	fsck compares superblocks
Date: Sun, 27 Jan 2008 00:25:35 -0500
Message-ID: <20080127052535.GD24842@mit.edu>
References: <479629DF.7090500@redhat.com> <479A2AA6.1020002@redhat.com> <20080127042216.GB24842@mit.edu> <479C0DBE.4000606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46907 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbYA0FZn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2008 00:25:43 -0500
Content-Disposition: inline
In-Reply-To: <479C0DBE.4000606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 26, 2008 at 10:51:10PM -0600, Eric Sandeen wrote:
> Theodore Tso wrote:
> > This is what I've checked in.  See the comment about why we can't
> > ignore a difference for the extended attribute feature.
> 
> Ok.  Unfortunately, that one really hurts on fedora, or any distro which
> writes xattrs during install.

The right fix is to simply force the extended attribute features on in
mke2fs.  We can do this in mke2fs.conf.  I plan to change it so that
by default it's enabled for ext3 filesystems.

						- Ted
