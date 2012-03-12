From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/54] libext2fs: Read and write full size inodes
Date: Mon, 12 Mar 2012 18:53:29 -0400
Message-ID: <20120312225329.GA5363@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235727.11945.11066.stgit@elm3b70.beaverton.ibm.com>
 <20120309233631.GE5635@thunk.org>
 <20120312222325.GM15164@tux1.beaverton.ibm.com>
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
Received: from li9-11.members.linode.com ([67.18.176.11]:59780 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab2CLWxp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 18:53:45 -0400
Content-Disposition: inline
In-Reply-To: <20120312222325.GM15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 12, 2012 at 03:23:25PM -0700, Darrick J. Wong wrote:
> 
> I'll send out patches to fix the other 45 failures this afternoon; I traced
> most of them to a mistake I made in e2fsck/rehash.c.

Do you have a github login?  It will be a lot easier if you just
update the patch queue at:

	https://github.com/tytso/e2fsprogs-cksum-patch-queue

							- Ted
