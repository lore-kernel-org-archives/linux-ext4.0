From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 16:47:14 +0530
Message-ID: <ea11fea30905140417i53c252cbra7c8041021d425e1@mail.gmail.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu>
	<20090514110659.GA5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34960 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbZENLRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 07:17:33 -0400
Received: by gxk10 with SMTP id 10so2297665gxk.13
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 04:17:34 -0700 (PDT)
In-Reply-To: <20090514110659.GA5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 4:37 PM, Kevin Shanahan <kmshanah@ucwb.org.au> =
wrote:
> On Thu, May 14, 2009 at 12:40:11AM -0400, Theodore Tso wrote:
>> On Wed, May 13, 2009 at 03:56:34PM +0930, Kevin Shanahan wrote:
>> >
>> > Now, this is (possibly) interesting - that block contains a bunch =
of
>> > file data. Looks like a html email (I can tell it's email because =
of
>> > the FIXED_ prefix added to the tags by the mail sanitizer).
>>
>> That is interesting. =A0Knowing that it is file data means we might =
be
>> able to track things down this way.
>>
>> Are you able to apply the following patch to your kernel?

Hi Ted,

If we have the possibility of applying patches why not apply this too
and try http://markmail.org/message/e3uwzxrd42isxczg . After all it
originated from this bug only.

Thanks -
Manish


>> If so,
>> hopefully we'll be able to catch whatever is causing the problem in
>> the act.
>
> Sure - now running with 2.6.29.3 + your patch.
>
> =A0patching file fs/ext4/inode.c
> =A0Hunk #1 succeeded at 1040 with fuzz 1 (offset -80 lines).
> =A0Hunk #2 succeeded at 1113 (offset -81 lines).
> =A0Hunk #3 succeeded at 1184 (offset -93 lines).
>
> I'll report any hits for "check_block_validity" in syslog.
>
> Thankyou, much appreciated.
>
> Cheers,
> Kevin.
>
>> commit 8ff799da106e9fc4da9b2a3753b5b86caab27f13
>> Author: Theodore Ts'o <tytso@mit.edu>
>> Date: =A0 Thu May 14 00:39:48 2009 -0400
>>
>> =A0 =A0 ext4: Add a block validity check to ext4_get_blocks_wrap()
>>
>> =A0 =A0 A few users with very large disks have been reporting low bl=
ock number
>> =A0 =A0 filesystem corruptions, potentially zapping the block group
>> =A0 =A0 descriptors or inodes in the first inode table block. =A0It'=
s not clear
>> =A0 =A0 what is causing this, but most recently, it appears that wha=
tever is
>> =A0 =A0 trashing the filesystem metadata appears to be file data. =A0=
So let's
>> =A0 =A0 try to set a trap for the corruption in ext4_get_blocks_wrap=
(), which
>> =A0 =A0 is where logical blocks in an inode are mapped to physical b=
locks.
>>
>> =A0 =A0 Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 4e7f363..4fad4fa 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1120,6 +1120,35 @@ static void ext4_da_update_reserve_space(stru=
ct inode *inode, int used)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_discard_preallocations(inode);
>> =A0}
>>
>> +static int check_block_validity(struct inode *inode, sector_t logic=
al,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t p=
hys, int len)
>> +{
>> + =A0 =A0 ext4_fsblk_t valid_block, itable_block;
>> + =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(inode->i_sb)->s_es=
;
>> + =A0 =A0 struct ext4_group_desc *gdp =3D ext4_get_group_desc(inode-=
>i_sb, 0, 0);
>> + =A0 =A0 unsigned int itable_len =3D EXT4_SB(inode->i_sb)->s_itb_pe=
r_group;
>> +
>> + =A0 =A0 valid_block =3D le32_to_cpu(es->s_first_data_block) +
>> + =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(inode->i_sb)->s_gdb_count;
>> + =A0 =A0 itable_block =3D ext4_inode_table(inode->i_sb, gdp);
>> +
>> + =A0 =A0 if (unlikely((phys <=3D valid_block) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((phys + len - 1) > ext4_blocks=
_count(es)) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((phys >=3D itable_block) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (phys <=3D itable_block + itab=
le_len)) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((phys + len - 1 >=3D itable_bl=
ock) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (phys + len - 1 <=3D itable_bl=
ock + itable_len)))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(inode->i_sb, "check_block_valid=
ity",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"inode #%lu logical=
 block %llu mapped to %llu "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"(size %d)", inode-=
>i_ino,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long=
) logical,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long=
) phys, len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> + =A0 =A0 }
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0/*
>> =A0 * The ext4_get_blocks_wrap() function try to look up the request=
ed blocks,
>> =A0 * and returns if the blocks are already mapped.
>> @@ -1165,6 +1194,13 @@ int ext4_get_blocks_wrap(handle_t *handle, st=
ruct inode *inode, sector_t block,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 up_read((&EXT4_I(inode)->i_data_sem));
>>
>> + =A0 =A0 if (retval > 0 && buffer_mapped(bh)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D check_block_validity(inode, bl=
ock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0bh->b_blocknr, retval);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 /* If it is only a block(s) look up */
>> =A0 =A0 =A0 if (!create)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return retval;
>> @@ -1241,6 +1277,12 @@ int ext4_get_blocks_wrap(handle_t *handle, st=
ruct inode *inode, sector_t block,
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 up_write((&EXT4_I(inode)->i_data_sem));
>> + =A0 =A0 if (retval > 0 && buffer_mapped(bh)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D check_block_validity(inode, bl=
ock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0bh->b_blocknr, retval);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> + =A0 =A0 }
>> =A0 =A0 =A0 return retval;
>> =A0}
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
