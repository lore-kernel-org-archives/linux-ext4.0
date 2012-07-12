From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug in filefrag?
Date: Thu, 12 Jul 2012 11:22:00 -0400
Message-ID: <20120712152200.GA14792@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC804A4CE@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38709 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab2GLPWD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jul 2012 11:22:03 -0400
Content-Disposition: inline
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A4CE@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 12, 2012 at 03:04:44PM +0000, Nelson, John R wrote:
> I did ran filefrag on a 100GB file and it showed it in 82 extents,
> when i did filefrag -v it went all the way down to 1038 Total
> extents.. So which is correct? 82 extents or 1038 extents?

Both, really.

The first means that you have 82 contiguous regions in your 100 gig
file.  That's not bad at all, and reflects the fact that there is
intervening file system metadata.  Each chunk is over a gigabyte on
average, and a seek every 1.2 gigabytes is not going to be noticeable.

The reason you are seeing 1038 extents reflects the fact that an entry
in a leaf node of the extent tree has a 15-bit length field, which
given a 4k block size, means that each extent descriptor can only
cover 128 megabytes.  So we simply use multiple entries in an extent
tree's leaf node for each adjacent 128 megabyte segment.  Since
filefrag -v shows you each physical extent descriptor, you'll see this.

Filefrag -v has many uses, including for filesystem developers who are
trying to debug performance issues, so it shows this greater amount of
detail.

Regards,

					- Ted

P.S.  The "expected" field shows the discontinuities,  For example:

% filefrag -v /u1/02\ Agent\ Afloat.m4v 
Filesystem type is: ef53
File size of /u1/02 Agent Afloat.m4v is 596714332 (145683 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    34816           32768 
   1   32768    67584           30720 
   2   63488   100352    98304  32768 
   3   96256   133120           30720 
   4  126976   165888   163840  18432 
   5  145408   164865   184320    275 eof

In line #1, the physical + length fields is 67584 + 30720 = 98304.
That's the physical block number we would hope to see in line #2 if
that extent were physically contiguous with the previous one (and
which you can see in the "expected" column).  In fact, it wasn't; the
starting physical block number for extent #2 was 100352.

The fact that there are 3 discontinuities means that the file has 4
extents, comprising the logical block ranges: 0 -- 63487, 63488 --
126975, 126976 -- 145407, and 145408 -- 145682.  Hence:

/u1/02 Agent Afloat.m4v: 4 extents found



