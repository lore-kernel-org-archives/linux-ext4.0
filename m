From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] mke2fs: fix hugefile creation so the hugefile(s) are
 contiguous
Date: Fri, 23 Jun 2017 17:19:36 -0400
Message-ID: <20170623211936.ei6775gjmgbfwcmt@thunk.org>
References: <20170623000009.27984-1-tytso@mit.edu>
 <20170623191925.GC84943@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38128 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754138AbdFWVTi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 17:19:38 -0400
Content-Disposition: inline
In-Reply-To: <20170623191925.GC84943@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 23, 2017 at 12:19:25PM -0700, Eric Biggers wrote:
> It's not quite that simple.  The presence of backup superblocks can also cause a
> discontinuity.  If I remove 'num_backup_sb = 0' from mke2fs.conf, I see:
> 
> 	PHYSICAL DISCONTINUITY between extents:
> 		  2  2 219 220 1073545216  1073577983 1073676288  1073709055  32768 
> 		  2  2 220 220 1073577984  1073610398 1073709409  1073741823  32415 
> 
> Also, for packed_meta_blocks to take effect, flex_bg must be enabled.  This is
> documented in mke2fs(8) but not in mke2fs.conf(5).

Good point.  I'll phrase it this way instead in the manpage.

  This boolean relation enables the creation of pre-allocated files as
  part of formatting the file system.  The extent tree blocks for these
  pre-allocated files will be placed near the beginning of the file
  system, so that if all of the other metadata blocks are also configured
  to be placed near the beginning of the file system (by disabling the
  backup superblocks, using the packed_meta_blocks option, etc.), the data
  blocks of the pre-allocated files will be contiguous.

This technically accurate, but admittedly doesn't go into a huge
amount of details about how to actually make it work if you really
want it.

My original thinking was that this was something fairly specialized
that very few people would want, and I didn't want to make the
documentation too verbose and ultimately more confusing.  

> Perhaps there should be an option hugefiles_contiguous which makes the mke2fs
> command fail if the hugefiles can't be allocated contiguously?

I suspect the better thing to do is to somehow make it easy for users
to make the hugefiles be allocated contiguously, as opposed to giving
an option which tells the user that they didn't quite get it right.
That seems a bit too much like the old joke:

   Ken Thompson has an automobile which he helped design. Unlike most
   automobiles, it has neither speedometer, nor gas gauge, nor any of
   the numerous idiot lights which plague the modern driver. Rather,
   if the driver makes any mistake, a giant "?" lights up in the
   center of the dashboard. "The experienced driver", he says, "will
   usually know what's wrong.

So perhaps just simply adding an example usage to the mke2fs.conf man
page, e.g.

[fs_types]
    hugefile = {
        features = extent,huge_file,bigalloc,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
        cluster_size = 32768
        reserved_ratio = 0.0
        num_backup_sb = 0
        packed_meta_blocks = 1
        make_hugefiles = 1
        inode_ratio = 4194304
        hugefiles_dir = /huge-dir
        hugefiles_name = huge-data
        hugefiles_digits = 0
        hugefiles_size = 0
        hugefiles_align = 256M
        num_hugefiles = 1
        zero_hugefiles = false
	flex_bg_size = 262144
    }

I'm going to save making this change as a separate commit, though,
since I want to get the bug fix commit out sooner rather than later.

	      	     	    	    	- Ted
