From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Fri, 16 Sep 2011 09:55:03 +0300
Message-ID: <CAOQ4uxgDc3Pen-1zGTpZtRbch+8p+wtwk-9ynzQie=tM22KjFg@mail.gmail.com>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
	<20110915131606.GG15782@thunk.org>
	<CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
	<F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:36792 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1IPGzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 02:55:06 -0400
Received: by wyj26 with SMTP id 26so4350253wyj.11
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 23:55:04 -0700 (PDT)
In-Reply-To: <F609F599-7286-4E6C-93B2-FEB9F9F5C077@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 10:08 PM, Andreas Dilger
<adilger.kernel@dilger.ca> wrote:
> On 2011-09-15, at 7:47 AM, Amir Goldstein wrote:
>> On Thu, Sep 15, 2011 at 4:16 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>> On Thu, Sep 15, 2011 at 09:50:20AM +0300, Amir Goldstein wrote:
>>>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 =A0 =A00x0080
>>>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 0x0080 not used =
*/
>>>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP =A0 =A0 0x0100
>>>
>>> Why this change? =A0Is it because you're already using 0x0100 in
>>> shipping systems?
>>
>> I am using 0x80 in shipping systems and it signifies something a bit
>> different then the proposed 0x100.
>>
>> EXCLUDE_INODE means that special inode 9 is used to reference exclud=
e
>> bitmap blocks. =A0EXCLUDE_BITMAP means that exclude bitmap blocks ar=
e
>> referenced from group descriptors.
>> With this distinction it will be easier for me to make the migration=
=2E
>
> In that light, why not continue to use an inode to map the exclude bi=
tmap
> blocks, where the bitmap offset is (group * blocksize), instead of
> explicitly listing all of the blocks in the group descriptor? =A0This=
 is
> how the buddy bitmap works in memory only, but it could be done for t=
he
> exclude bitmap on disk.
>
> The advantage of this is that it would allow the 32-bit bitmap checks=
ums
> to both fit into the group descriptor. =A0The disadvantage is that th=
ere
> is a chance this inode would become corrupted and the location of the
> exclude bitmaps is lost. =A0I don't know how serious that is (e.g. if=
 e2fsck
> could fix it by regenerating the bitmaps, or just deleting the snapsh=
ot).
>
> Cheers, Andreas
>

fsck can fix it. it just marks all blocks used by snapshot inodes.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
