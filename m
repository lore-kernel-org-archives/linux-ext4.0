From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 14/16] ext4: Make inode checksum cover empty space
Date: Fri, 2 Sep 2011 11:42:06 -0700
Message-ID: <20110902184206.GF12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003207.31048.55390.stgit@elm3c44.beaverton.ibm.com> <4540D5DB-53D9-4C33-BC6B-868870D42AF3@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48974 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1IBSm1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 14:42:27 -0400
Content-Disposition: inline
In-Reply-To: <4540D5DB-53D9-4C33-BC6B-868870D42AF3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 01:43:53AM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:32 PM, Darrick J. Wong wrote:
> > Extend the inode checksum to cover the empty space between the end of the
> > inode's data fields and the end of the space allocated for the inode.  This
> > enables us to cover extended attribute data that might live in the empty space.
> 
> I'm not sure that this should be a separate patch from the first inode
> checksum patch, but probably isn't harmful.

The only reason why it's separate is that this patch enables checksumming of
in-inode EA blocks.  If someone wants me to reduce the patch count I can merge
them, but ... there's plenty of other things to work on.

--D
> 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > fs/ext4/inode.c |    4 +---
> > 1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 44a7f88..e24ba98 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -53,7 +53,6 @@
> > static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> > {
> > 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > -	struct ext4_inode_info *ei = EXT4_I(inode);
> > 	int offset = offsetof(struct ext4_inode, i_checksum);
> > 	__le32 inum = cpu_to_le32(inode->i_ino);
> > 	__u32 crc = 0;
> > @@ -70,8 +69,7 @@ static __le32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> > 	crc = crc32c_le(crc, (__u8 *)raw, offset);
> > 	offset += sizeof(raw->i_checksum); /* skip checksum */
> > 	crc = crc32c_le(crc, (__u8 *)raw + offset,
> > -		    EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize -
> > -		    offset);
> > +		    EXT4_INODE_SIZE(inode->i_sb) - offset);
> > 	return cpu_to_le32(crc);
> > }
> > 
> > 
> 
