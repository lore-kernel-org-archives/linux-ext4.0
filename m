From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Wed, 18 May 2011 13:20:24 -0400
Message-ID: <20110518172024.GF29368@thunk.org>
References: <4D9A17F8.4000406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Zeev Tarantov <zeev.tarantov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43680 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab1ERRUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 13:20:32 -0400
Content-Disposition: inline
In-Reply-To: <4D9A17F8.4000406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 04, 2011 at 03:11:52PM -0400, Eric Sandeen wrote:
> Block devices may set minimum or optimal IO hints equal to
> blocksize; in this case there is really nothing for ext4
> to do with this information (i.e. search for a block-aligned
> allocation?) so don't set fs geometry with single-block
> values.
> 
> Zeev also reported that with a block-sized stripe, the
> ext4 allocator spends time spinning in ext4_mb_scan_aligned(),
> oddly enough.
> 
> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the maint branch of e2fsprogs (which will be merged up to
the next/master branches), thanks!!

						- Ted
