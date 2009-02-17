From: Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
Subject: Re: EXT3 file system with unsupported revision level can be mounted
 in R/W mode
Date: Tue, 17 Feb 2009 17:50:44 +0900
Message-ID: <499A7A64.8040608@uniadex.co.jp>
References: <4885AFBF.2010409@uniadex.co.jp> <48A90371.6070700@uniadex.co.jp> <48A9439C.4010007@uniadex.co.jp> <48B5B2BC.4050303@redhat.com> <D457AE0D137B9143B30CDD9EB9B2F8D509FDD525@ZZ01X1MB24.ixas.unisys.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from igw04.unisys.co.jp ([202.233.47.14]:32080 "EHLO
	igw04.unisys.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZBQJUt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Feb 2009 04:20:49 -0500
In-Reply-To: <D457AE0D137B9143B30CDD9EB9B2F8D509FDD525@ZZ01X1MB24.ixas.unisys.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


>> ----------
>> diff -up linux-2.6.26.2/fs/ext3/super.c.orig
>> linux-2.6.26.2/fs/ext3/super.c
>=20
> For what it's worth, ext2 and ext4 have the same problems...
>=20
>> --- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.00000000=
0
>> +0900
>> +++ linux-2.6.26.2/fs/ext3/super.c      2008-08-18 11:06:29.00000000=
0 +0900
>> @@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
>>                 goto failed_mount4;
>>         }
>>
>> -       ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
>> +       if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
>> +                sb->s_flags |=3D MS_RDONLY;
>>         /*
>>          * akpm: core read_super() calls in here with the superblock=
 locked.
>>          * That deadlocks, because orphan cleanup needs to lock the
>> superblock @@ -2506,8 +2507,8 @@ static int ext3_remount (struct sup=
er_bl
>>                         sbi->s_mount_state =3D le16_to_cpu(es->s_sta=
te);
>>                         if ((err =3D ext3_group_extend(sb, es,
>> n_blocks_count)))
>=20
> One other thing I worry about; we are doing group_extend before we ch=
eck the revision.  Is that safe?  We also still do things like replay t=
he journal and process orphan inodes before checking the revision.
>=20
> Should we even worry about this, or is the revision level never going=
 to change again, and we can almost just ignore it now?  (or assume tha=
t for recent kernels, a too-high rev level indicates corruption and fai=
l the
> mount?)
>=20
> -Eric
>=20

Sorry for the long delay in my response.
I agree that the mount of a file with a too-high revision level should =
be rejected,
if the current revision level is never going to change again, because t=
he too-high
revision level must be an indication of some corruption in this case.
The problem is when we should fail the mount. It seems to be too late t=
o fail the mount
after the related super block has been updated in group_extend or clear=
_journal_error.
It=92ll be safe to make the revision somewhere earlier stage, at least =
before doing
clear_journal_error and group_extend.

If the current revision level can be changed in the near feature, the r=
ecommended action
will depend on how a file system with the next revision is implemented.=
 If it must be
mounted with read only mode as the current revision check code in setup=
_super intends,
the revision check also should be made before doing any process which m=
ay involve
updating the related super block.

Anyway, the original problem I like to let everyone know is that the cu=
rrent ext2/ext3/ext4
code allows a file with a too-high revision level to be mounted with re=
ad & write enabled,
while the following error message is issued by the revision check:
     "EXTx-fs warning: revision level too high, forcing read-only mode"
Please remember the problem again and let me know your opinion what we =
should do for it.
The code should be updated so that the file would be mounted with read =
only mode or
the message should be changed?

Thank you.
Signed-off-by :Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>

>>                                 goto restore_opts;
>> -                       if (!ext3_setup_super (sb, es, 0))
>> -                               sb->s_flags &=3D ~MS_RDONLY;
>> +                       if (ext3_setup_super (sb, es, 0))
>> +                               *flags &=3D ~MS_RDONLY;
>>                 }
>>         }
>>  #ifdef CONFIG_QUOTA
>> ----------
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
> .
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
