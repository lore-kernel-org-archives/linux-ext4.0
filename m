From: Jan Kara <jack@suse.cz>
Subject: Re: block allocator issue with ext4+DAX
Date: Thu, 31 Mar 2016 10:59:25 +0200
Message-ID: <20160331085925.GC11041@quack.suse.cz>
References: <20160330220129.GA9101@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160330220129.GA9101@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 30-03-16 16:01:29, Ross Zwisler wrote:
> I've hit an issue in my testing which I believe to be related to the ext4
> block allocator when using the DAX mount option.  I originally found this
> issue with the generic/102 xfstest, but have reduced it to the minimal
> reproducer at the bottom of this email.  I've been able to reproduce this with
> both BRD and with PMEM as the underlying block device.
> 
> For this test we're running in a very small filesystem, only 512 MiB.  We
> fallocate() 400 MiB of that space, unlink the file, then try and rewrite that
> 400 MiB file one chunk at a time.
> 
> What actually happens is that during the rewrite we run out of memory and the
> DAX call to get_block() in dax_io() fails with -ENOSPC.

Yes, I have already sent a fix for this bug here:

http://www.spinics.net/lists/linux-ext4/msg51649.html

Ted, can you please pick it up? Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
