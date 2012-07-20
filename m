From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [BUG] ext4: i_size, EOFBLOCKS_FS corruption with xfstests 269
Date: Fri, 20 Jul 2012 13:49:26 +0900
Message-ID: <5008E356.7070306@rs.jp.nec.com>
References: <50066C93.1070006@rs.jp.nec.com> <alpine.LFD.2.00.1207181137190.2291@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52037 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2GTEtv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jul 2012 00:49:51 -0400
In-Reply-To: <alpine.LFD.2.00.1207181137190.2291@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,

> thanks for reporting this. Could you please try to use the most
> recent e2fsprogs ? The EOFBLOCKS_FL has been removed from e2fsprogs
> with:
>
> 010dc7b90d97b93907cbf57b3b44f1c1cad234f6 e2fsck: remove
> EXT4_EOFBLOCKS_FL flag handling

Thanks for comment, yes,
both e2fsck outputs I reported have gone with the latest e2fsprogs
(37c8db7b2078d0310e5676404e21cc143d8e4d56).

> and is about to be removed from kernel as well, so the EOFBLOCKS_FL
> problem probably does not even matter. Though the i_size problem
> might be real.

The patch also fixes i_size problem.
Because the last uninitialized extent (~~~ in below)
whose offset exceeds i_size and is not checked with the latest e2fsck.

# debugfs: stat <1237>
     Inode: 1237   Type: regular    Mode:  0666   Flags: 0x80000
     Generation: 2257700857    Version: 0x00000000:00000001
     User:  1870   Group:  1899   Size: 440021
     File ACL: 0    Directory ACL: 0
     Links: 1   Blockcount: 256
     Fragment:  Address: 0    Number: 0    Size: 0
      ctime: 0x5007a2a0:ee09d6a0 -- Thu Jul 19 15:01:04 2012
      atime: 0x5007a2ae:7dbe4e64 -- Thu Jul 19 15:01:18 2012
      mtime: 0x5007a2a0:ee09d6a0 -- Thu Jul 19 15:01:04 2012
     crtime: 0x5007a283:31ed0abc -- Thu Jul 19 15:00:35 2012
     Size of extra inode fields: 28
     EXTENTS:
     (12-38):49820-49846, (106):13714, (107):41292, (108-110[u]):41293-=
41295
                                                    ~~~~~~~~~~~~~~~~~~~=
~~~~~

Regards,
Akira Fujita

(2012/07/18 18:40), Luk=C3=A1=C5=A1 Czerner wrote:
> On Wed, 18 Jul 2012, Akira Fujita wrote:
>
>> Date: Wed, 18 Jul 2012 16:58:11 +0900
>> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>> To: Theodore Tso <tytso@mit.edu>
>> Cc: ext4 development <linux-ext4@vger.kernel.org>
>> Subject: [BUG] ext4: i_size, EOFBLOCKS_FS corruption with xfstests 2=
69
>>
>> Hi,
>>
>> I got a issue which makes i_size and EOFBLOCKS_FL corrupted
>> on ext4 with xfstests 269.
>> In my environment (linux-3.5-rc7), this can be reproduced
>> once of 10 times trial.
>>
>> Kernel: 3.5-rc7
>> Arch: x86_64
>>
>> Step and log are as bellow, after xfstests 269, e2fsck outputs
>> i_size and EOFBLOCKS_FL corruption.
>> Is this an already known issue?
>
> Hi Akira,
>
> thanks for reporting this. Could you please try to use the most
> recent e2fsprogs ? The EOFBLOCKS_FL has been removed from e2fsprogs
> with:
>
> 010dc7b90d97b93907cbf57b3b44f1c1cad234f6 e2fsck: remove
> EXT4_EOFBLOCKS_FL flag handling
>
> and is about to be removed from kernel as well, so the EOFBLOCKS_FL
> problem probably does not even matter. Though the i_size problem
> might be real.
>
> Not sure if it is a known problem, but I've certainly seen it before
> with xfstest 269, though I have not had time to look at this yet. So
> I guess I should :).
>
> Thanks!
> -Lukas
>
>>
>> # ./check 269
>>      FSTYP         -- ext4
>>      PLATFORM      -- Linux/x86_64 mcds1 3.5.0-rc7
>>      MKFS_OPTIONS  -- /dev/sdb3
>>      MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdb3 /mnt/mp2
>>
>>      269 97s ... [failed, exit status 1] - output mismatch (see 269.=
out.bad)
>>      --- 269.out	2012-07-02 10:51:34.000000000 +0900
>>      +++ 269.out.bad	2012-07-18 14:09:03.000000000 +0900
>>      @@ -3,3 +3,4 @@
>>       Run fsstress
>>
>>       Run dd writers in parallel
>>      +_check_generic_filesystem: filesystem on /dev/sdb3 is inconsis=
tent (see 269.full)
>>      Ran: 269
>>      Failures: 269
>>      Failed 1 of 1 tests
>>
>>
>>      # cat 269.full
>>        (snip)
>>
>>      e2fsck 1.41.12 (17-May-2010)
>>      Pass 1: Checking inodes, blocks, and sizes
>>      Inode 2336, i_size is 625045, should be 1277952.  Fix? no
>>
>>      Inode 3193 should not have EOFBLOCKS_FL set (size 1928717, lblk=
 218)
>>      Clear? no
>>
>>      Inode 4198 should not have EOFBLOCKS_FL set (size 380389, lblk =
73)
>>      Clear? no
>>
>>
>> Regards,
>> Akira Fujita
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
