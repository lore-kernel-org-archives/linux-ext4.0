From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2undo: cast dptr to blk64_t to retrieve block number
Date: Fri, 18 Nov 2011 17:45:57 -0500
Message-ID: <20111118224557.GB4130@thunk.org>
References: <4EC44889.7050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33312 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808Ab1KRWp7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Nov 2011 17:45:59 -0500
Content-Disposition: inline
In-Reply-To: <4EC44889.7050307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 05:34:33PM -0600, Eric Sandeen wrote:
> A 32-bit s390 build was failing on a 64-bit s390x host, when
> make check failed e2undo tests, like this:
> 
> md5sum before mke2fs 922c8a591c882dbdd1a381d18547cfd5
> using mke2fs to test e2undo
> Overwriting existing filesystem; this can be undone using the command:
>     e2undo /tmp/mke2fs-tmp.EM9XjmTA81.e2undo /tmp/tmp.EM9XjmTA81
> 
> md5sum after mke2fs cbf32fb6c3db45280ad013f42ac294f1
> Replayed transaction of size 32768 at location 0
> Replayed transaction of size 32768 at location 0
> Replayed transaction of size 32768 at location 0
> Replayed transaction of size 32768 at location 0
> Replayed transaction of size 0 at location 0
> md5sum after e2undo 31b4e14307c5b7ccce5b8d300c2ad5f1
> 
> Note the "at location 0" for the block number.
> 
> A proper cast in e2undo.c fixes this up.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
