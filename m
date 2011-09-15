From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Thu, 15 Sep 2011 13:08:34 -0600
Message-ID: <F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com> <20110915131606.GG15782@thunk.org> <CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57838 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472Ab1IOTIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 15:08:42 -0400
In-Reply-To: <CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 7:47 AM, Amir Goldstein wrote:
> On Thu, Sep 15, 2011 at 4:16 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Thu, Sep 15, 2011 at 09:50:20AM +0300, Amir Goldstein wrote:
>>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE      0x0080
>>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE   0x0080 not used */
>>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP     0x0100
>> 
>> Why this change?  Is it because you're already using 0x0100 in
>> shipping systems?
> 
> I am using 0x80 in shipping systems and it signifies something a bit
> different then the proposed 0x100.
> 
> EXCLUDE_INODE means that special inode 9 is used to reference exclude
> bitmap blocks.  EXCLUDE_BITMAP means that exclude bitmap blocks are
> referenced from group descriptors.
> With this distinction it will be easier for me to make the migration.

In that light, why not continue to use an inode to map the exclude bitmap
blocks, where the bitmap offset is (group * blocksize), instead of
explicitly listing all of the blocks in the group descriptor?  This is
how the buddy bitmap works in memory only, but it could be done for the
exclude bitmap on disk.

The advantage of this is that it would allow the 32-bit bitmap checksums
to both fit into the group descriptor.  The disadvantage is that there
is a chance this inode would become corrupted and the location of the
exclude bitmaps is lost.  I don't know how serious that is (e.g. if e2fsck
could fix it by regenerating the bitmaps, or just deleting the snapshot).

Cheers, Andreas





