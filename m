From: Theodore Tso <tytso@mit.edu>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 14:25:52 -0400
Message-ID: <20080731182552.GJ11632@mit.edu>
References: <20080731161058.GA20838@skywalker> <20080731164728.GF11632@mit.edu> <20080731170856.GD20838@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40050 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753416AbYGaSZ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 14:25:56 -0400
Content-Disposition: inline
In-Reply-To: <20080731170856.GD20838@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 10:38:56PM +0530, Aneesh Kumar K.V wrote:
> 
> Also note that fallocate is called with update i_size option.
> 

Are you sure about this?  I can replicate the problem using Eric's
fallocate problem if i_size is not updated:

<tytso.root@closure> {/tmp}, level 2  
509# touch /mnt/foo
<tytso.root@closure> {/tmp}, level 2  
510# ./fallocate -n  -l 10m /mnt/foo
<tytso.root@closure> {/tmp}, level 2  
511# ls -al /mnt/foo
10240 -rw-r--r-- 1 root root 0 2008-07-31 14:24 /mnt/foo
<tytso.root@closure> {/tmp}, level 2  
512# umount /mnt
<tytso.root@closure> {/tmp}, level 2  
513# e2fsck -fy /dev/thunk/testext4
e2fsck 1.41.0 (10-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 0, should be 10485760.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/thunk/testext4: ***** FILE SYSTEM WAS MODIFIED *****
/dev/thunk/testext4: 12/65536 files (16.7% non-contiguous), 15205/262144 blocks

  	      	    	   		    		 - Ted
