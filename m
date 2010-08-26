From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Thu, 26 Aug 2010 22:15:17 +0800
Message-ID: <AANLkTinNDYamXF-rvFH1JCdeP7Lom=fkqetF7cGOkW0E@mail.gmail.com>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com>
 <1282326704-14838-4-git-send-email-lczerner@redhat.com> <AANLkTimRZ5Cbi7k+=-fQzc8ywpb6u-s19f7UdFdpMJFt@mail.gmail.com>
 <alpine.LFD.2.00.1008261342280.4071@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:32912 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0HZOPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 10:15:38 -0400
Received: by pxi10 with SMTP id 10so624690pxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 07:15:38 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1008261342280.4071@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Lukas,

On Thu, Aug 26, 2010 at 8:14 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Thu, 26 Aug 2010, Peng Tao wrote:
>
>> Hi, all,
>>
>> On Sat, Aug 21, 2010 at 1:51 AM, Lukas Czerner <lczerner@redhat.com>=
 wrote:
>> > When lazy_itable_init extended option is passed to mke2fs, it
>> > considerably speed up filesystem creation because inode tables are=
 left
>> > uninitialized, thus contains some old data. When this fs is mounte=
d
>> > filesystem code should initialize (zero out) uninitialized inode t=
able.
>> > So far this code was missing for ext4 and this patch adds this fea=
ture.
>> >
>> > When file system is mounted with "inititable" mount option, new th=
read
>> > (called itableinitd) is created. This thread walks through allocat=
ion
>> > groups searching for the group with not yet initialized inode tabl=
e.
>> > When such a group is found it write zeroes through whole inode tab=
le and
>> > put itself into sleep for defined number of seconds to not disturb=
 other
>> > ongoing I/O. This is repeated until it walks through every allocat=
ion group
>> > then the iitableinitd thread is stopped.
>> This will slow down e2fsck speed that is gained from uninitialized
>> italbe. Am I missing something? What about having another block grou=
p
>> flag to tell itable that is just zeroed but not used, from itable th=
at
>> is already in use?
>>
>
> Hi,
>
> this is probably my bad. I should have used term "zeroed inode table"=
 instead
> of "initialized inode table". You see, there are two flags.
>
> * EXT4_BG_INODE_UNINIT tells us that inode BITMAP was not used yet, t=
hus
> =C2=A0no inode was allocated from that group just yet, so kernel need=
 not to
> =C2=A0read this bitmap from the disk and rather construct fresh (zero=
ed)
> =C2=A0inode bitmap in memory (see ext4_init_inode_bitmap).
>
> * EXT4_BG_INODE_ZEROED tells us whether or not inode TABLE was
> =C2=A0zeroed out. This is the flag which is set by the mkfs when
> =C2=A0lazy_itable_init extended option is set. This flag was not used
> =C2=A0for anything useful in kernel, nor e2fsck until now.
>
> Se when the thread is done zeroing the inode table it sets the
> EXT4_BG_INODE_ZEROED flag, but leaves EXT4_BG_INODE_UNINIT as is, so
> e2fsck should not be any slower.
I see it. Thank you very much for the explanation.



--=20
Thanks,
-Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
