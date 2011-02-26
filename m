From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] e2image: Add support for qcow2 format
Date: Sat, 26 Feb 2011 11:28:26 -0500
Message-ID: <20110226162826.GC2924@thunk.org>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35312 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1BZQ2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Feb 2011 11:28:30 -0500
Content-Disposition: inline
In-Reply-To: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 01:49:30PM +0100, Lukas Czerner wrote:
> This commit adds support for exporting filesystem into QCOW2 image
> format. Like sparse format this saves space, by writing only necessary
> (metadata blocks) into image. Unlike sparse image, QCOW2 image is NOT
> sparse, hence does not change its size by copying with not-sparse-aware
> tools.
> 
> New options '-Q' has been added to tell the e2image to use QCOW2 as an
> output image format. QCOW2 supports encryption and compression, however
> e2image so far does no support such features, however you can still
> scramble filenames with '-s' option.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

I noticed that the qcow2 functions have a qcow2_ prefix and aren't
prefixed with ext2_.  That's a namespace leakage, although I
understand why adding ext2_ to functions that really have nothing to
do with ext2_ might not make sense.

What this *does* make me wonder though, is whether or not we should
split off qcow2 into its own separate library...

						- Ted
