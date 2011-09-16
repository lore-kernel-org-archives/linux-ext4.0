From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Fri, 16 Sep 2011 14:22:06 -0600
Message-ID: <1D75A7AC-0707-4952-B765-7BBC307E6CE0@dilger.ca>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com> <20110915131606.GG15782@thunk.org> <CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com> <F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca> <20110915215759.GG28181@thunk.org> <CAOQ4uxg1W2WQE-SsBKnjNKnwquRUuXPxhYaDbnkMRQNt23jqsA@mail.gmail.com> <CAGBYx2YR6o0HG3xrvNJC6mp8d3Eh+3R_j_JHkdHXKFtp3p7ubA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Amir Goldstein <amir73il@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27573 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1IPUWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 16:22:09 -0400
In-Reply-To: <CAGBYx2YR6o0HG3xrvNJC6mp8d3Eh+3R_j_JHkdHXKFtp3p7ubA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-16, at 5:43 AM, Yongqiang Yang wrote:
> On Fri, Sep 16, 2011 at 2:45 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> No, I am not sure this is accurate.
>> I think after we over viewed the e2fsprogs snapshots patch set, you
>> has 2 observations:
>> 1. the largest part (in lines of code) of the e2fsprogs snapshot patch set
>>    is related to the exclude inode/bitmap code.
>> 2. it reminded you of resize inode too much and you didn't like that
>> 3. There was also the issue of whether or not to allow the removal of
>> the exclude inode/bitmap
>>    and then re-allocation would not be in optimal layout
>> 
>> In retrospect, after Yongqiang has implemented the alternative exclude
>> bitmap patch set
>> for e2fsprogs, I can say:
>> 1. The alternative patch set is not smaller
>> 2. It is a lot more elegant and deals with correct layout of exclude
>> bitmap (next to block bitmap)
>> 3. It will be able to deal with 64bit fs (unlike exclude/resize inode)
>> and 64bit resize
>> 
>> Yongqiang, do you have anything else to add to the exclude inode vs.
>> group desc issue?
> 
> Nope, regarding resize group desc is better than exclude inode.  For
> meta_bg, group desc is much more welcome.

I'm not dead-set on using the exclude inode.  I was just wondering if there
was a clear benefit to doing so.  I'm OK with having 16-bit checksums for
the inode bitmaps for now, and possibly changing mke2fs to always creating
ext4 filesystems with the 64bit feature.  Always specifying 64bit for ext4
filesystems will allow larger checksums, and has the added benefit of
facilitating resize from below 2^32 blocks to over 2^32 blocks as well.

One minor drawback is the size of the s_group_desc array doubles in size, so
the allocation needs to be larger (handled in newer kernels by ext4_kvmalloc())
and it needs more space on disk.  At 16TB the group descriptor table would
use 8MB instead of 4MB, and at 256TB the group descriptor table would fill
the whole 128MB of the first group, where we HAVE to use META_BG because the
second group is also filled with the backup GDT.

Cheers, Andreas





