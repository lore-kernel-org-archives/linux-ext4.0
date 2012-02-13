From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/23] ext4: Add new feature to make block group
 checksums use metadata_csum algorithm
Date: Mon, 13 Feb 2012 17:28:28 -0500
Message-ID: <20120213222828.GF21641@thunk.org>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
 <20120107082919.21970.99182.stgit@elm3c44.beaverton.ibm.com>
 <8ED6E1F9-DB56-4D31-BCA8-2A3A8D514BD5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
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
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48995 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab2BMW2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 17:28:46 -0500
Content-Disposition: inline
In-Reply-To: <8ED6E1F9-DB56-4D31-BCA8-2A3A8D514BD5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 13, 2012 at 02:40:26PM -0700, Andreas Dilger wrote:
> 
> If a kernel understands METADATA_CSUM, it will check this first and
> ignore whether GDT_CSUM is set or not (though it shouldn't ever be
> set at the same time).  Either of these features will cause an older
> kernel to mount the filesystem read-only, which is all that is needed.

... note that when we check for the uninit bits, this will have to be
done if GDT_CSUM || METADATA_CSUM are set.

					- Ted
