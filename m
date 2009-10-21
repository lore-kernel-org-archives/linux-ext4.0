From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix configure.in typo
Date: Wed, 21 Oct 2009 03:52:32 -0400
Message-ID: <20091021075232.GA9574@mit.edu>
References: <4ADE8477.2070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51243 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZJUHwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 03:52:51 -0400
Content-Disposition: inline
In-Reply-To: <4ADE8477.2070906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 20, 2009 at 10:48:07PM -0500, Eric Sandeen wrote:
> I think vim <esc>wq turned into <esc>2wq or something; in any case
> blkid_probe_get_topology2 is not the right thing to search for.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
> (note; with this, once I try to build w/ a new libblkid, I still
> get a mkfs build error ... it's still picking up the in-tree blkid
> headers)

Hmmm... which in-tree header files is it picking up?  And what error
are you seeing?

There are a few header files that I can see that we should probably
clean-up, but they don't look like they should be problematic.

build.static/lib/blkid/blkid_types.h -- just simple type definitions
lib/blkid/blkidP.h ---  only used by lib/blkid/*.c
lib/blkid/list.h --- only used by lib/blkid/*.c
lib/blkid/probe.h -- only used by lib/blkid/probe.c



