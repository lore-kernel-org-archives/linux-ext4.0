From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Thu, 31 May 2007 12:16:27 -0400
Message-ID: <20070531161627.GE19088@thunk.org>
References: <1179777153.3910.13.camel@garfield> <20070525143957.GA12669@thunk.org> <1180128981.3916.13.camel@garfield> <1180558715.3949.3.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33808 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXEaQQ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 12:16:29 -0400
Content-Disposition: inline
In-Reply-To: <1180558715.3949.3.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 31, 2007 at 02:28:33AM +0530, Kalpak Shah wrote:
> 
> So can I assume that the INCOMPAT_MMP flag and the s_mmp_interval and
> s_mmp_block superblock fields will be reserved regardless of whether the
> patches go into ext4? I had attached the patches in the last mail so you
> can share your views on them.

Yes, i've reserved the code point and superblock fields.  I'm not
going to add INCOMPAT_MMP flag to the supported file until I get and
integrate the patch ext2fs_open() that actually tests for the flag,
though, since that would be a bit silly.

I assume the patch will add a flag to ext2fs_open which skips the MMP
checking.  After all, tune2fs is allowed to make changes to the
superblock while the filesystem is mounted.  So it needs to be able to
open the filesystem read/only even if it is mounted.

Regards,

						- Ted
