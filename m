From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [patch 1/1] ext4: use proper little-endian bitops
Date: Fri, 29 Jul 2011 13:51:22 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1107291341540.4293@dhcp-27-109.brq.redhat.com>
References: <201107282055.p6SKtKp5008047@imap1.linux-foundation.org> <alpine.LFD.2.00.1107291109460.4293@dhcp-27-109.brq.redhat.com> <CAC5umyjxG3k2L3mozmd-Dfb08mMt1ZEZdrsAdhAjbZTkEy_OoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-778767869-1311940286=:4293"
Cc: Lukas Czerner <lczerner@redhat.com>, amir73il@gmail.com,
	xiaoqiangnk@gmail.com, akpm@linux-foundation.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1G2Lvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jul 2011 07:51:32 -0400
In-Reply-To: <CAC5umyjxG3k2L3mozmd-Dfb08mMt1ZEZdrsAdhAjbZTkEy_OoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-778767869-1311940286=:4293
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 29 Jul 2011, Akinobu Mita wrote:

> 2011/7/29 Lukas Czerner <lczerner@redhat.com>:
> 
> >> diff -puN fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops fs/ext4/ext4.h
> >> --- a/fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops
> >> +++ a/fs/ext4/ext4.h
> >> @@ -931,12 +931,13 @@ struct ext4_inode_info {
> >>  #define test_opt2(sb, opt)           (EXT4_SB(sb)->s_mount_opt2 & \
> >>                                        EXT4_MOUNT2_##opt)
> >>
> >> -#define ext4_set_bit                 __test_and_set_bit_le
> >> +#define ext4_test_and_set_bit                __test_and_set_bit_le
> >> +#define ext4_set_bit                 __set_bit_le
> >>  #define ext4_set_bit_atomic          ext2_set_bit_atomic
> > We can remove this since it is not used anywhere and it is just a macro
> > for test_and_set_bit_le() anyway.
> 
> Amir Goldstein requested not to remove it because ext4 snapshot patches is
> using ext4_set_bit_atomic(), although I really don't know about the status of
> mainline inclusion.

It is not anywhere near inclusion. Moreover it is using
__test_and_set_bit_le, but the name does not really imply *test*.
So please, just remove it and when Amir is going to
need it someday he might add proper define with the proper name using
the proper set, or test_and_set functions.

Thanks!
-Lukas

> 
> > Other than that it looks good. You can add my
> >
> > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> Thanks.
> 

-- 
--8323328-778767869-1311940286=:4293--
