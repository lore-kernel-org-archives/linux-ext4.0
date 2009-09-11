From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Fri, 11 Sep 2009 14:15:41 -0400
Message-ID: <20090911181541.GA28764@mit.edu>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com> <20090909225429.GB24951@mit.edu> <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com> <20090910013540.GF24951@mit.edu> <20090910065401.GB8690@skywalker.linux.vnet.ibm.com> <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com> <20090910162435.GA5321@skywalker.linux.vnet.ibm.com> <20090910185826.GC23700@mit.edu> <20090911172125.GA10155@skywalker.linux.vnet.ibm.com> <20090911180827.GC19707@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40590 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZIKSPk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 14:15:40 -0400
Content-Disposition: inline
In-Reply-To: <20090911180827.GC19707@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2009 at 02:08:27PM -0400, Theodore Tso wrote:
> Does that help clarify matters?  Basically, there are three separate
> bugs related to no journal mode that are being addressed by patches in
> the ext4 patch queue:

Whoops, I mixed up the patch names and description for two of them.
Let me try again:

ext4: Make non-journal fsync work properly
      (Found and fixed by Frank; we need to explicitly write out the 
      inode structure to disk during an fsync since we can't depend 
      on the journal doing this for us in no-journal mode.  So this is 
      an issue of the inode itself not getting written out by
      ext4_write_inode, which is called by pdflush and fsync.  
      Since the inode table buffer is marked dirty, the inode will 
      *eventually* be written out, but on a much greater time scale.  
      This caused the increased fragility of ext4 in no-journal mode
      after a power failure.)

ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
      (Found by Curt, with an initial fix that worked by forcing 
      the dirty buffer to be written to disk, and fixed in a better way 
      by Ted by using bforget.  The problem here relates to an inode that
      is being deleted, which is why there's no reason to write the 
      dirty block to disk; when we were about to deallocate the block ---
      the better fix is to drop the dirty bit by using bforget.)

ext4: Assure that metadata blocks are written during fsync in no journal mode
      (Pointed out by Aneesh, fixed by Ted; this fix makes sure that
      fsync will write out an inode's extent tree and/or indirect blocks,
      which is kinda important.  :-)

(I swapped the patch names/description for the last two.)

> Hopefully this quick Cliff Notes(tm) summary of the ext4 no-journal
> patches in the ext4 patch queue is helpful.

  	     	      	    	     - Ted
