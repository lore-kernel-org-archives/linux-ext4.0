From: Drew Reusser <dreusser@gmail.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 17:00:59 +0000
Message-ID: <CAPAnFc9tSbB-PJ97B77FAfsusdtpTppB9uu=cmDc0NWgRjW=5Q@mail.gmail.com>
References: <20121119083245.18044.qmail@science.horizon.com>
	<50AA503D.2060503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:62105 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2KSRBB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 12:01:01 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1259035lag.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 09:00:59 -0800 (PST)
In-Reply-To: <50AA503D.2060503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 3:29 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 11/19/12 2:32 AM, George Spelvin wrote:
> ...
>
>> "e2fsck -n" will only print errors and not change anything.  It's
>> always safe.
>>
>> Try "e2fsck -n -v /dev/md0" (given the dumpe2fs failure, I expect that
>> will not work) and then try "e2fsck -n -v -b 32768 /dev/md0".
>>
>> I don't know what happened to your superblock, but if that's all that
>> got trashed, recovery is actually quite straightforward and there's no
>> risk of data loss.  e2fsck will just print a huge number of "free blocks
>> count wrong" messages as it fixes them.
>>
>> (However, that's a pretty big "if".)
>>
>>
>> Another thing that would be useful is "dd if=/dev/md0 skip=2 count=2 | xxd"
>> (or od -x if you don't have xxd).  That will give a hex dump of the
>> primary superblock, which might show the extent of the damage.
>>
>>
>> If "e2fsck -n -b 32768" works, the way to repair it is to run it again
>> without the "-n", but the -n output will say how bad it is.
>
> Whoops, I replied without seeing these other replies; somehow threading
> was broken w/ George's first reply.
>
> Anyway - I would not go to e2fsck yet.  I think your raid is mis-assembled.
> I'd investigate that first.  I'll look at the other output a bit more, but
> for now, I'd stay away from fsck - just wanted to get that out there quick.
>
> -Eric

Can you give me more details as to why you think the raid is misassembled?

mint ~ # mdadm --examine /dev/sd[abde]1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 11:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 933ec5c0:d6819e33:adb0e6c8:90e337bd

    Update Time : Thu Nov 15 15:08:55 2012
       Checksum : b516984f - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 11:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9d6df7c7:ce401405:4ea18763:a528ecc5

    Update Time : Thu Nov 15 15:08:55 2012
       Checksum : 3103c408 - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 11:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fa1a1b82:989e933a:95e4d249:5cee901d

    Update Time : Thu Nov 15 15:08:55 2012
       Checksum : 5ea6d02d - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 11:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 594ed481:471ef11a:027f1c24:6f9d057d

    Update Time : Thu Nov 15 15:08:55 2012
       Checksum : 786bd4bc - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)
