From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Sun, 4 Sep 2011 10:04:19 -0400
Message-ID: <20110904140419.GE3461@thunk.org>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com>
 <0151C905-AE23-4729-92B9-9EAFA44A92FD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33073 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab1IDOE2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Sep 2011 10:04:28 -0400
Content-Disposition: inline
In-Reply-To: <0151C905-AE23-4729-92B9-9EAFA44A92FD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 03, 2011 at 12:05:39PM -0600, Andreas Dilger wrote:
> Why not just get rid of ext2_inode and replace it with
> ext2_inode_large?  Less change to the code, and less confusion for
> developers.

struct ext2_inode_large is there to make sure we don't break ABI
compatibility for shared libraries.

						- Ted
