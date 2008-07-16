From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 01/15][e2fsprogs] libext2fs: Add 64-bit support to the
	undo manager
Date: Wed, 16 Jul 2008 09:26:28 -0400
Message-ID: <20080716132628.GS8185@mit.edu>
References: <20080715164332.28567.27913.stgit@ichigo> <20080715165008.28567.22096.stgit@ichigo> <873ama2i51.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60169 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755957AbYGPN0c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 09:26:32 -0400
Content-Disposition: inline
In-Reply-To: <873ama2i51.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 01:16:58PM +0200, Goswin von Brederlow wrote:
> Why not this?
> 
> +static errcode_t undo_read_blk64(io_channel channel, blk64_t block,
> +				 int count, void *data);
> 
> libext2fs specifically has blk_t and blk64_t types to represent a
> block. Why not use them? It is less to type and easier to read.

It's an abstraction layer thing.  blk64_t is defined in ext2fs.h, and
the io_managers don't include it.  The I/O managers are a small amount
of code, and it hasn't been worth it to explicitly define a type just
for them in the header file.

						- Ted
