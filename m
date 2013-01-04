From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Fri, 4 Jan 2013 14:37:09 -0500
Message-ID: <20130104193709.GA6501@thunk.org>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
 <20130101203858.GB12554@thunk.org>
 <20130104040505.GA27833@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41751 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab3ADThO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2013 14:37:14 -0500
Content-Disposition: inline
In-Reply-To: <20130104040505.GA27833@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2013 at 12:05:05PM +0800, Zheng Liu wrote:
> >
> > I'm a bit concenred about this abstraction.  Consider what happens if
> > wanted is greater than a block size --- for example, consider if
> > wanted is 16k, and every other 1k block is uninitialized.
>
> Hi Ted,
>
> I wonder why wanted is 16k.  If a program calls ext2fs_file_read()
> function, seek will be 0 and SEEK flag won't be marked.  The behavior of
> ext2fs_file_read() is the same as before.  If ext2fs_file_read2() is
> called by dump_file(), seek won't be 0 and wanted is always equal to
> block size.  That is why I fix the hard-coded buffer length in dump_file().
> If I miss something, please let me know.

The problem is that ext2fs_file_read() is an exported function, and
there are users of this API/ABI outside of e2fsprogs.

The goal of this function is that it should look like the read system
call, and the caller might not know what the blocksize might be.  So
if the caller uses a 4k fixed size buffer, and the underlying file
system blocksize is 1k, this function needs to work properly.

So consider what happens if some program, perhaps an ext[234] FUSE
driver (there are two or three of them out there), or the e2tools
package, uses a 4k or 16k buffer --- this is legal, and they call the
existing ext2fs_file_read() library function.  In your patch,
ext2fs_file_read() will call ext2fs_file_read2(), and it will skip the
sparse blocks, and since the returned seek pointer is null, there's no
possible way for the caller of the ext2fs_file_read() would know this
had happened --- and even if there was a way, we don't ever change the
semantics/behaviour of an existing functional interface unless it's a
clear bug (and even then we need to think very carefully about the
backwards compatibility implications).

Regards,

                                                - Ted
