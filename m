From: <tadao.uchiyama@uniadex.co.jp>
Subject: RE: EXT3 file system with unsupported revision level can be mounted
 in R/W mode
Date: Fri, 29 Aug 2008 20:34:41 +0900
Message-ID: <D457AE0D137B9143B30CDD9EB9B2F8D509FDD582@ZZ01X1MB24.ixas.unisys.co.jp>
References: <4885AFBF.2010409@uniadex.co.jp>
 <48A90371.6070700@uniadex.co.jp> <48A9439C.4010007@uniadex.co.jp>
 <48B5B2BC.4050303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from igw03.unisys.co.jp ([202.233.47.13]:56729 "EHLO
	igw03.unisys.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYH2Lff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 07:35:35 -0400
In-Reply-To: <48B5B2BC.4050303@redhat.com>
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> For what it's worth, ext2 and ext4 have the same problems...

Thanks a lot for the first response! I really appreciate it.

>> --- linux-2.6.26.2/fs/ext3/super.c.orig 2008-08-18 11:01:02.000000000 +0900
>> +++ linux-2.6.26.2/fs/ext3/super.c      2008-08-18 11:06:29.000000000 +0900
>> @@ -1898,7 +1898,8 @@ static int ext3_fill_super (struct super
>>                 goto failed_mount4;
>>         }
>>
>> -       ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
>> +       if (ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY))
>> +                sb->s_flags |= MS_RDONLY;
>>         /*
>>          * akpm: core read_super() calls in here with the superblock locked.
>>          * That deadlocks, because orphan cleanup needs to lock the
>> superblock @@ -2506,8 +2507,8 @@ static int ext3_remount (struct super_bl
>>                         sbi->s_mount_state = le16_to_cpu(es->s_state);
>>                         if ((err = ext3_group_extend(sb, es,
>> n_blocks_count)))

> One other thing I worry about; we are doing group_extend before we check
> the revision.  Is that safe?  We also still do things like replay the
> journal and process orphan inodes before checking the revision.
>
> Should we even worry about this, or is the revision level never going
> to change again, and we can almost just ignore it > > now?  (or assume
> that for recent kernels, a too-high rev level indicates corruption and
> fail the
> mount?)
>
> -Eric

I think I need more time to find an appropriate answer, but I'll be keeping busy for a while. Please wait. Could anyone give us some suggestion? Any comments would be highly appreciated.

> >                                 goto restore_opts;
> > -                       if (!ext3_setup_super (sb, es, 0))
> > -                               sb->s_flags &= ~MS_RDONLY;
> > +                       if (ext3_setup_super (sb, es, 0))
> > +                               *flags &= ~MS_RDONLY;
> >                 }
> >         }
> >  #ifdef CONFIG_QUOTA
> > ----------
> > --

Thanks.
Signed-off-by :Tadao Uchiyama <Tadao.Uchiyama@uniadex.co.jp>
