From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: avoid double free of ctx->filesystem_name
	in e2fsck
Date: Mon, 7 Apr 2008 11:51:30 -0400
Message-ID: <20080407155130.GC11997@mit.edu>
References: <n7x4paegdje.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46378 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759951AbYDGPvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 11:51:47 -0400
Content-Disposition: inline
In-Reply-To: <n7x4paegdje.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2008 at 12:33:25PM +0200, Matthias Koenig wrote:
> Hi,
> 
> in current git there is a double free on ctx->filesystem_name in the end of
> main() and in e2fsck_free_context, causing e2fsck to abort at the end of
> pass5.

Oops.  Thanks for pointing that out.  I've checked this into the
master branch.

					- Ted
