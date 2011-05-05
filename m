From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Is it possible for the ext4/btrfs file system to pass some
	context related info to low level block driver?
Date: Thu, 5 May 2011 12:10:32 -0600
Message-ID: <20110505181032.GA21360@parisc-linux.org>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com> <yq1mxj32932.fsf@sermon.lab.mkp.net> <CE761E84DADF2947A4AF22FB8D97A47358EE526A@shsmsx501.ccr.corp.intel.com> <60C31100-5694-4CA9-A778-91CB15915052@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Gao, Yunpeng" <yunpeng.gao@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58554 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1EESKe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 14:10:34 -0400
Content-Disposition: inline
In-Reply-To: <60C31100-5694-4CA9-A778-91CB15915052@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 04, 2011 at 08:51:39AM -0600, Andreas Dilger wrote:
> I was aware of REQ_META, but I didn't know there was any benefit to
> using it. I think it would be easy to set REQ_META on all ext4 metadata
> if there was a reason to do so.

The CFQ ioscheduler pays attention to it (prioritising metadata accesses
over data accesses), and blocktrace will print an 'M' for metadata
requests if it's set, so I think that's two excellent reasons to set
REQ_META today.

However, ext3, ext4, and XFS already use it:

fs/ext3/inode.c:1105:   ll_rw_block(READ_META, 1, &bh);
fs/ext3/inode.c:2754:           submit_bh(READ_META, bh);
fs/ext3/namei.c:924:                                    ll_rw_block(READ_META, 1, &bh);
fs/ext4/inode.c:1500:   ll_rw_block(READ_META, 1, &bh);
fs/ext4/inode.c:4775:           submit_bh(READ_META, bh);
fs/ext4/namei.c:924:                                    ll_rw_block(READ_META, 1, &bh);
fs/gfs2/log.c:597:              submit_bh(WRITE_SYNC | REQ_META, bh);
fs/gfs2/log.c:599:              submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
fs/gfs2/meta_io.c:39:   int write_op = REQ_META |
fs/gfs2/meta_io.c:228:  submit_bh(READ_SYNC | REQ_META, bh);
fs/gfs2/meta_io.c:435:          ll_rw_block(READ_SYNC | REQ_META, 1, &first_bh);
fs/gfs2/ops_fstype.c:221:       submit_bio(READ_SYNC | REQ_META, bio);
fs/gfs2/quota.c:710:            ll_rw_block(READ_META, 1, &bh);
fs/xfs/linux-2.6/xfs_buf.c:1321:                rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
include/linux/fs.h:164:#define READ_META                (READ | REQ_META)
include/linux/fs.h:168:#define WRITE_META               (WRITE | REQ_META)

btrfs seems to not use REQ_META yet.  *poke* *poke* :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
