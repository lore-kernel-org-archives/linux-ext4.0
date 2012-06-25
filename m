From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4_fallocate
Date: Mon, 25 Jun 2012 01:33:35 -0600
Message-ID: <13363B8E-7411-4AA3-8835-F9DEF67B2ABE@dilger.ca>
References: <4FE8086F.4070506@zoho.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Fredrick <fjohnber@zoho.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34959 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2FYHdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2012 03:33:37 -0400
In-Reply-To: <4FE8086F.4070506@zoho.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-25, at 12:42 AM, Fredrick wrote:
> When calling fallocate on ext4 fs, ext4_fallocate does not initialize
> the extents.

The whole point of fallocate() is that the extents are uninitialized
(i.e. not zero-filled with data, but read back as if they were), and
only overwritten with user data as needed.

> The extents are allocated only when they are actually
> written. This is causing a problem for us. Our programs create many
> "write only once" files as large as 1G on ext4 very rapidly at times.
> We thought fallocate would solve the problem. But it didnt.
> If I change the EXT4_GET_BLOCKS_CREATE_UNINIT_EXT to
> just EXT4_GET_BLOCKS_CREATE in the ext4_map_blocks in the ext4_fallocate call, the extents get created in fallocate call itself. This is helping us.

This means that if any user reads the fallocate'd file, they will be able
to read any old data that was previously written to disk and deleted.  This
is a big security hole.  Also, if the writer of such a file is interrupted
for some reason, the file will contain garbage in it.

There was a recent patch series "ext4: add an io-tree to track block
allocation" that may improve the performance for your case of overwrite
of uninitialized files, but it hasn't landed yet.

> Now the write throughtput to the disk was close to 98%. When extents were not
> initialized, our disk throughput were only 70%.
> 
> Can this change be made to ext4_fallocate?

Not if you value data security.  That said, it is possible some users value
performance over security on systems that have limited access, or do not
have any private data on them.  If the "io-tree" doesn't fix the performance
problem, it may make sense to add a mount option to allow users to specify
that uninitialized extents can return old data from disk, but before that
happens, I'd really prefer to make the correct behaviour work efficiently.

Cheers, Andreas





