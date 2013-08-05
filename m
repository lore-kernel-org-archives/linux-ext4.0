From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Tue, 6 Aug 2013 07:14:34 +0800
Message-ID: <20130805231434.GA3784@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
 <20130805173452.GA9203@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63004 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3HEXOX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 19:14:23 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so3862629pad.2
        for <linux-ext4@vger.kernel.org>; Mon, 05 Aug 2013 16:14:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130805173452.GA9203@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 10:34:52AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 02, 2013 at 05:49:30PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > We need to define some functions to operate extended attribute in order
> > to support inline data.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  lib/ext2fs/ext2_err.et.in  |    3 +
> >  lib/ext2fs/ext2_ext_attr.h |   31 ++++++++
> >  lib/ext2fs/ext2fs.h        |    9 +++
> >  lib/ext2fs/ext_attr.c      |  186 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 229 insertions(+)
> > 
> > diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> > index d20c6b7..7e6d6e5 100644
> > --- a/lib/ext2fs/ext2_err.et.in
> > +++ b/lib/ext2fs/ext2_err.et.in
> > @@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
> >  ec	EXT2_ET_FILE_EXISTS,
> >  	"Ext2 file already exists"
> >  
> > +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> > +	"Extended attribute currupted"
> 
> "corrupted".

Thanks for pointing it out.  Fix it in next spin.

> 
> (Or maybe shorten that to "corrupt"?)

I find the 'CORRUPT' in lib/ext2fs/ext2_err.et.in, and the result are as
below.

$ grep CORRUPT lib/ext2fs/ext2_err.et.in
ec      EXT2_ET_DIR_CORRUPTED,
ec      EXT2_ET_CORRUPT_SUPERBLOCK,
ec      EXT2_ET_RESIZE_INODE_CORRUPT,
ec      EXT2_ET_TDB_ERR_CORRUPT,

It seems that there is no any rule about this.  I am wondering if we
need to rename _DIR_CORRUPTED to _DIR_CORRUPT.  I am ok for using
_CORRUPT or _CORRUPTED.

Regards,
                                                - Zheng
