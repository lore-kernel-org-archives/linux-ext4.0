From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Disallow bigalloc with with bs < 4096
Date: Wed, 3 Apr 2013 10:35:54 -0400
Message-ID: <20130403143554.GA13668@thunk.org>
References: <1364997099-22590-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58931 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab3DCOf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 10:35:59 -0400
Content-Disposition: inline
In-Reply-To: <1364997099-22590-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 03:51:39PM +0200, Lukas Czerner wrote:
> Currently there is nothing preventing user to create file system with
> bigalloc feature enabled and block size smaller than 4096 Bytes. However
> such combination does not make much sense at all because the whole point
> of bigalloc is to have bigger allocation units.
> 
> This patch disallow such combination.

This makes sense by default but I do see a point in allowing it for
testing purposes --- specifically, it allows us to verify that
bigalloc works on architectures such as PowerPC and Itanium where page
size is greater than the 4k block size.  So maybe a developer mode set
via mke2fs.conf?

Another option would be to enforce that we only support bigalloc file
systems where the blocksize == pagesize, but that means we wouldn't be
able to mount 4k bigalloc file systems on architectures with a 8k or
16k page size.

						- Ted
