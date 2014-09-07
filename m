From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use mkfs.ext4 -F instead of piping in yes
Date: Sun, 7 Sep 2014 15:21:10 -0400
Message-ID: <20140907192110.GC1066@thunk.org>
References: <1410092942-22201-1-git-send-email-tytso@mit.edu>
 <20140907154927.GA23630@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	Eryu Guan <eguan@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42617 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbaIGTVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Sep 2014 15:21:23 -0400
Content-Disposition: inline
In-Reply-To: <20140907154927.GA23630@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2014 at 08:49:27AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 07, 2014 at 08:29:02AM -0400, Theodore Ts'o wrote:
> > Using "yes | mkfs.ext4 ..." results in the error message results in
> > the test failing, at least for some versions of e2fsprogs:
> > 
> >     +yes: standard output: Broken pipe
> >     +yes: write error
> > 
> > It better to use the -F option, which will eliminate the questions.
> 
> Looks good, but maybe we should have a $MKFS_EXT4_PROG variable similar
> to $MKFS_XFS_PROG so that we can set this in one place?

Agreed, I'll send a separate patch to fix that.   One amusing thing:

% git grep mkfs.ext4
common/rc:_scratch_mkfs_ext4()
common/rc:      _scratch_mkfs_ext4 $*
common/rc:# this test requires the bigalloc feature to be available in mkfs.ext4
common/rc:      _scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1 \
common/rc:         || _notrun "mkfs.ext4 doesn't have bigalloc feature"
common/rc:      _scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1
tests/btrfs/012:MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
tests/btrfs/012:_require_command $MKFS_EXT4_PROG mkfs.ext4
tests/ext4/003:mkfs.ext4 -F -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
tests/ext4/306:mkfs.ext4 -F -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1

(note the btrfs test is the one place using and defining MKFS_EXT4_PROG :-)

      	  	     	    	      	       - Ted

