From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 10/22] ext4: Verify and calculate checksums for extent
	tree blocks
Date: Mon, 5 Dec 2011 11:50:16 -0800
Message-ID: <20111205195016.GE7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232725.19194.12626.stgit@elm3c44.beaverton.ibm.com> <20111205164015.GD32031@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43893 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab1LETua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 14:50:30 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 5 Dec 2011 14:50:29 -0500
Content-Disposition: inline
In-Reply-To: <20111205164015.GD32031@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 05, 2011 at 11:40:15AM -0500, Ted Ts'o wrote:
> On Mon, Nov 28, 2011 at 03:27:25PM -0800, Darrick J. Wong wrote:
> >  /*
> > + * This is the extent tail on-disk structure.
> > + * All other extent structures are 12 bytes long.  It turns out that
> > + * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).
> 
> More generally, block_size % 12 is >= 4 for all powers of 2 greater
> than 12 bytes.  I'd probably remove (1k, 2k, 4k) because that might
> scare people who might say, "hey!  I'm using a 16k block size on my
> HPC system running on a Power or Itanium box --- am I going to be OK?".
> Valid block sizes go up to the page size of the hardware in question...

Ok.

--D

