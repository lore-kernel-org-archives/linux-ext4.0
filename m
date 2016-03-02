From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 bug: getdents uninterruptible for 117 seconds
Date: Wed, 2 Mar 2016 16:43:30 -0500
Message-ID: <20160302214330.GB24012@thunk.org>
References: <20160302171511.GM12913@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbcCBVne (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Mar 2016 16:43:34 -0500
Content-Disposition: inline
In-Reply-To: <20160302171511.GM12913@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 02, 2016 at 12:15:11PM -0500, Benjamin LaHaise wrote:
> Hi folks,
> 
> While working on a bug involving write starvation, the test I was running 
> managed to trigger some pretty horrific worst case behaviour in ext4.  The 
> filesystem I'm working on is about 4TB in size, and is used for storing a 
> number of spool files across 100 subdirectories in the filesystem.  One of 
> these subdirectories ended up growing to ~497MB in size.  Once all of the 
> files were removed from these directories, the filesystem was unmounted.  
> On subsequent mounts of the filesystem, it became apparent that whenever 
> a specific directory was accessed using ls or find, the kernel would block 
> in getdents() for north of 117 seconds.  It is clear that ext4 is slowly 
> reading the entire contents of the directory into memory during this time 
> at a rate of ~4MB/s.  This filesystem is being stored on an external 8Gbps 
> FC SAN comprised of about 8 x 10Krpm spindles.
> 
> I've placed a copy of the e2image for the filesystem at 
> http://www.kvack.org/~bcrl/ext4/ext4-readdir.img.xz .  The problematic 
> directory is broken/1.  The relevant snippet of strace output is below.  
> Thoughts?

Yes, this is a known problem.  Right now we don't have a way of
removing empty directory blocks from a directory.  This can be fixed
up by running "e2fsck -fD /dev/sdXX" off-line, but it's not terribly
satisfying.

There are things we could do in theory try to make things better, but
they haven't been implemented yet.  In practice they tend to happen
with pathological workloads, but they do happen occasionally in real
life.  It's just not something we've had time to address up until now.

       	    	     	       	     - Ted
