From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 32/37] libext2fs: Extend inode checksum to cover the EA
 block
Date: Wed, 14 Sep 2011 12:48:59 -0400
Message-ID: <20110914164859.GF3429@dhcp-172-31-195-159.cam.corp.google.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003836.1176.13428.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34276 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab1INQtF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 12:49:05 -0400
Content-Disposition: inline
In-Reply-To: <20110901003836.1176.13428.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:38:36PM -0700, Darrick J. Wong wrote:
> Now that e2fsprogs knows to read the entire s_inode_size, change the inode
> checksum code to checksum the entire block.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This should get folded into whatever patch actually starts
checksumming the inode.  There's no point keeping it separate.  Also
note that changes like this are problematic as we bisect the tree,
since the meaning of the fields change as we progess through time.
Although from a development perspective this may be the order in which
you did things, from a patch review perspective it's better if you
collapse functional changes together, especially when it relates to
"this is how we calculate this field in the
inode/superblock/whatever".

					- Ted
