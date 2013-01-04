From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Fri, 4 Jan 2013 12:05:05 +0800
Message-ID: <20130104040505.GA27833@gmail.com>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
 <20130101203858.GB12554@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:61787 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3ADDv1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jan 2013 22:51:27 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so7273514dak.34
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 19:51:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130101203858.GB12554@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 03:38:58PM -0500, Theodore Ts'o wrote:
> On Tue, Jan 01, 2013 at 08:30:15PM +0800, Zheng Liu wrote:
> > +errcode_t ext2fs_file_read2(ext2_file_t file, void *buf,
> > +			    unsigned int wanted, unsigned int *got,
> > +			    ext2_off64_t *seek)
> 
> I'm a bit concenred about this abstraction.  Consider what happens if
> wanted is greater than a block size --- for example, consider if
> wanted is 16k, and every other 1k block is uninitialized.

Hi Ted, 

I wonder why wanted is 16k.  If a program calls ext2fs_file_read()
function, seek will be 0 and SEEK flag won't be marked.  The behavior of
ext2fs_file_read() is the same as before.  If ext2fs_file_read2() is
called by dump_file(), seek won't be 0 and wanted is always equal to
block size.  That is why I fix the hard-coded buffer length in dump_file().
If I miss something, please let me know.

Thanks,
                                                - Zheng

> 
> Then ext2fs_file_read2() will return *got set to 8k, and *seek set to
> 8k, and the buffer will contain the blocks that are initialized packed
> up right against each other.
> 
> Worse, ext2fs_file_read() will do the same thing, so this commit
> changes how ext2fs_file_read() functions, and a program which expects
> to get the correct contents from the file will malfunction.
