From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Tue, 8 Dec 2009 22:21:11 -0500
Message-ID: <20091209032111.GZ27692@thunk.org>
References: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
 <20091204094654.GB4272@skywalker.linux.vnet.ibm.com>
 <6601abe90912041114m37284332pd568e13ed5beee2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40331 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZLIDVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 22:21:11 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90912041114m37284332pd568e13ed5beee2b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2009 at 11:14:40AM -0800, Curt Wohlgemuth wrote:
> > Can you name it as discard allocated blocks and add a comment saying why
> > we don't need it for MB_GROUP_PA ? Otherwise
> >
> > Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> This fixes a leak of blocks in an inode prealloc list if device failures
> cause ext4_mb_mark_diskspace_used() to fail.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Added to the ext4 patch queue, thanks.

					- Ted
