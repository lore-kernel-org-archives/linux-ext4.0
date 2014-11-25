From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't count external journal blocks as overhead
Date: Tue, 25 Nov 2014 16:33:02 -0500
Message-ID: <20141125213302.GF28449@thunk.org>
References: <54664C73.60409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51653 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaKYVdE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 16:33:04 -0500
Content-Disposition: inline
In-Reply-To: <54664C73.60409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 12:39:47PM -0600, Eric Sandeen wrote:
> This was fixed for ext3 with:
> 
> e6d8fb3 ext3: Count internal journal as bsddf overhead in ext3_statfs
> 
> but was never fixed for ext4.
> 
> With a large external journal and no used disk blocks, df comes
> out negative without this, as journal blocks are added to the
> overhead & subtracted from used blocks unconditionally.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
