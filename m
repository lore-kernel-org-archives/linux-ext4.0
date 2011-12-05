From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/22] ext4: Verify and calculate checksums for extent
 tree blocks
Date: Mon, 5 Dec 2011 11:40:15 -0500
Message-ID: <20111205164015.GD32031@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232725.19194.12626.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42486 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab1LEQkV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 11:40:21 -0500
Content-Disposition: inline
In-Reply-To: <20111128232725.19194.12626.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:27:25PM -0800, Darrick J. Wong wrote:
>  /*
> + * This is the extent tail on-disk structure.
> + * All other extent structures are 12 bytes long.  It turns out that
> + * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).

More generally, block_size % 12 is >= 4 for all powers of 2 greater
than 12 bytes.  I'd probably remove (1k, 2k, 4k) because that might
scare people who might say, "hey!  I'm using a 16k block size on my
HPC system running on a Power or Itanium box --- am I going to be OK?".
Valid block sizes go up to the page size of the hardware in question...

      	    	     	       	    	    - Ted
