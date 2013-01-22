From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs, tune2fs, resize2fs: add warning messages for
 bigalloc and quota
Date: Tue, 22 Jan 2013 13:45:53 -0500
Message-ID: <20130122184553.GA14705@thunk.org>
References: <1358813397-26528-1-git-send-email-tytso@mit.edu>
 <679935ED-C84D-42C4-B6C4-2F104774FBB0@redhat.com>
 <355F6D97-0481-45C8-805B-F2E2BF6118F8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <esandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44869 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab3AVSrF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 13:47:05 -0500
Content-Disposition: inline
In-Reply-To: <355F6D97-0481-45C8-805B-F2E2BF6118F8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2013 at 10:24:47AM -0700, Andreas Dilger wrote:
> 
> My preference would be to have separate "--force-bigalloc" and
> "--force-quota" options instead of lumping everything under a single
> "--force/-f" flag. That can become habitual for one kind of usage
> (e.g. mke2fs on a regular file) and then it also forces other
> dangerous behaviour (such as these) as an unknown side effect.

This would require us to figure out a backwards compatible way of
dealing with using getopt_long() for systems that don't have
getopt_long().  One of the things which I've been thinking about doing
in the 1.43 series is to rename libquota.a to libsupport.a, and then
moving e2fsck/profile.c and some of misc/util.c into libsupport.a.
Then we could optionally include the getopt_long() sources if we are
building on a system that doesn't have it.  This assumes that
getopt_long() is portable enough, and I don't know what kind of
dependencies it might drag in....

In the long term, I agree with you.

                                        - Ted

