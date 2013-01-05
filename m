From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Sat, 5 Jan 2013 12:45:22 +0800
Message-ID: <20130105044522.GA4203@gmail.com>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
 <20130101203858.GB12554@thunk.org>
 <20130104040505.GA27833@gmail.com>
 <20130104193709.GA6501@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33923 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3AEEbk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 23:31:40 -0500
Received: by mail-pa0-f49.google.com with SMTP id bi1so9694075pad.36
        for <linux-ext4@vger.kernel.org>; Fri, 04 Jan 2013 20:31:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130104193709.GA6501@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Sorry, I am still confused.  Maybe I misunderstand something.  Please
bear with me.

On Fri, Jan 04, 2013 at 02:37:09PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 04, 2013 at 12:05:05PM +0800, Zheng Liu wrote:
> > >
> > > I'm a bit concenred about this abstraction.  Consider what happens if
> > > wanted is greater than a block size --- for example, consider if
> > > wanted is 16k, and every other 1k block is uninitialized.
> >
> > Hi Ted,
> >
> > I wonder why wanted is 16k.  If a program calls ext2fs_file_read()
> > function, seek will be 0 and SEEK flag won't be marked.  The behavior of
> > ext2fs_file_read() is the same as before.  If ext2fs_file_read2() is
> > called by dump_file(), seek won't be 0 and wanted is always equal to
> > block size.  That is why I fix the hard-coded buffer length in dump_file().
> > If I miss something, please let me know.
> 
> The problem is that ext2fs_file_read() is an exported function, and
> there are users of this API/ABI outside of e2fsprogs.
> 
> The goal of this function is that it should look like the read system
> call, and the caller might not know what the blocksize might be.  So
> if the caller uses a 4k fixed size buffer, and the underlying file
> system blocksize is 1k, this function needs to work properly.

Yeah, Caller can use a fixed size buffer and needn't to care about the
underlying file system blocksize.

> 
> So consider what happens if some program, perhaps an ext[234] FUSE
> driver (there are two or three of them out there), or the e2tools
> package, uses a 4k or 16k buffer --- this is legal, and they call the
> existing ext2fs_file_read() library function.  In your patch,
> ext2fs_file_read() will call ext2fs_file_read2(), and it will skip the
> sparse blocks, and since the returned seek pointer is null, there's no
> possible way for the caller of the ext2fs_file_read() would know this
> had happened --- and even if there was a way, we don't ever change the
> semantics/behaviour of an existing functional interface unless it's a
> clear bug (and even then we need to think very carefully about the
> backwards compatibility implications).

Yes, some programs call ext2fs_file_read() with a 4k or 16k fixed size
buffer, and ext2fs_file_read() calls ext2fs_file_read2().  But it won't
skip the sparse blocks because when ext2fs_file_read2() is called in
ext2fs_file_read(), the last argument, namely 'seek', is 0.  That means
that in ext2fs_file_read2() 'flags' is 0.  Thus, in load_buffer()
'flags' is not equal to SEEK, and EXT2_FILE_BUF_VALID is marked.  Then
we return back to ext2fs_file_read2() and all data in file->buf is
copied.  So I think the behavior of ext2fs_file_read() doesn't be
changed.

On the other hand, if ext2fs_file_read2() is called by dump_file()
directly.  'seek' is not 0 and 'wanted' is equal to blocksize.  In
ext2fs_file_read2() 'flags' is assigned to SEEK and in load_buffer()
EXT2_FILE_BUF_VALID is not marked if it meets an uninitialized extent.

Am I missing something?  Thanks for your time.

Regards,
                                                - Zheng
