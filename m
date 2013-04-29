From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Reserve FEATURE_RO_COMPAT and INO flag
Date: Mon, 29 Apr 2013 12:35:18 -0600
Message-ID: <3CAF5E28-8718-4078-ACB9-607CA8DC5BA5@dilger.ca>
References: <1366900760-18899-1-git-send-email-lczerner@redhat.com> <2B5199BA-39D5-4118-B4FC-96C8B800507B@dilger.ca> <alpine.LFD.2.00.1304291454240.20016@localhost>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:36371 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab3D2SfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 14:35:21 -0400
Received: by mail-da0-f52.google.com with SMTP id j17so3063195dan.39
        for <linux-ext4@vger.kernel.org>; Mon, 29 Apr 2013 11:35:20 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1304291454240.20016@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-29, at 6:58 AM, Luk=E1=9A Czerner wrote:
> On Fri, 26 Apr 2013, Andreas Dilger wrote:
>> Date: Fri, 26 Apr 2013 05:47:58 -0600
>> From: Andreas Dilger <adilger@dilger.ca>
>> To: Lukas Czerner <lczerner@redhat.com>
>> Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
>>    Lukas Czerner <lczerner@redhat.com>
>> Subject: Re: [PATCH] ext4: Reserve FEATURE_RO_COMPAT and INO flag
>>=20
>> I was looking in the maint and master branches, but I don't see thes=
e flags anywhere?
>=20
> That's odd. I am using git repository:
>=20
> git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>=20
> and it is there added with the commit
> 991211f676f49c6cf30af368dade2f81287f1fa8 libext2fs, libe2p: Reserve
> RO_COMPAT_REPLICA feature

Strange, I see it now.  I don't know what file I was looking at
that didn't have this included...

One real problem that I see is that EXT4_REPLICA_INO uses the
last reserved inode.  I recall in the past that Ted wanted to
make this last reserved inode a hidden directory, so that it
would be possible to put special inodes in there and access them
by name.  Not quite as easy as accessing a reserved inode by
number, but still preferable to not being able to have filesystem
internal inodes at all in the future.

Of the currently-reserved inodes, the only other one that might
be a potential candidate for re-use is EXT2_UNDEL_DIR_INO, which
has never been used in any upstream kernel (Googling shows there
was a patch developed by some students, but never released
AFAICS).  The BOOT_LOADED_INO has recently seen interest for use
by Grub, and real patches exist for the snapshot code .

That leaves us in a quandry - change the meaning of a reserved
inode which has been publicly available for many years but never
really used, or change the meaning of a private reserved inode
which is (presumably) in use privately, but will (presumably) never
be landed?

IMHO, since EXT2_UNDEL_DIR_INO was already supposed to be a
directory it might be reasonable to repurpose it to be an "internal
files" directory, possibly even linking the existing reserved
directories to it by name for consistency?  This concept is used
by ZFS to store all kinds of configuration data, mount parameters
and tunables, etc. and is very handy IMHO.

Cheers, Andreas

>> On 2013-04-25, at 8:39, Lukas Czerner <lczerner@redhat.com> wrote:
>>=20
>>> EXT4_FEATURE_RO_COMPAT_REPLICA and EXT4_REPLICA_INO are reserved in
>>> e2fsprogs for non-upstream feature. However it has never been reser=
ved
>>> in kernel, fix this. Thanks to Radek Pazdera to pointing it out.
>>>=20
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>> ---
>>> fs/ext4/ext4.h |    3 +++
>>> 1 files changed, 3 insertions(+), 0 deletions(-)
>>>=20
>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>> index 3b83cd6..6369c28 100644
>>> --- a/fs/ext4/ext4.h
>>> +++ b/fs/ext4/ext4.h
>>> @@ -241,6 +241,7 @@ struct ext4_io_submit {
>>> #define EXT4_UNDEL_DIR_INO     6    /* Undelete directory inode */
>>> #define EXT4_RESIZE_INO         7    /* Reserved group descriptors =
inode */
>>> #define EXT4_JOURNAL_INO     8    /* Journal inode */
>>> +#define EXT4_REPLICA_INO     10    /* Used by non-upstream feature=
 */
>>>=20
>>> /* First non-reserved inode for old ext4 filesystems */
>>> #define EXT4_GOOD_OLD_FIRST_INO    11
>>> @@ -1481,6 +1482,8 @@ static inline void ext4_clear_state_flags(str=
uct ext4_inode_info *ei)
>>> * GDT_CSUM bits are mutually exclusive.
>>> */
>>> #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
>>> +/* Reserved for non-upstream feature */
>>> +#define EXT4_FEATURE_RO_COMPAT_REPLICA        0x0800
>>>=20
>>> #define EXT4_FEATURE_INCOMPAT_COMPRESSION    0x0001
>>> #define EXT4_FEATURE_INCOMPAT_FILETYPE        0x0002
>>> --=20
>>> 1.7.7.6
>>>=20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
