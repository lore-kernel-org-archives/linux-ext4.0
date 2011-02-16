From: Javi <javier.cabezas@gmail.com>
Subject: Re: Heavy disk I/O on temporary mmap'ed files (ext4)
Date: Wed, 16 Feb 2011 02:33:22 -0600
Message-ID: <AANLkTim2UH9z3wvqWprAjdgsFMb+kjp6uP4kQbMkjkXT@mail.gmail.com>
References: <AANLkTikKWibkcV+ErcBe=C0oT3cyWH_2rfE9uv3qxsSN@mail.gmail.com> <AANLkTi=tnrgspm4A1uPOboXLbWvXdd1is28FfbtTreY-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37999 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1BPIdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Feb 2011 03:33:43 -0500
Received: by qyj19 with SMTP id 19so3349959qyj.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 00:33:42 -0800 (PST)
In-Reply-To: <AANLkTi=tnrgspm4A1uPOboXLbWvXdd1is28FfbtTreY-@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am using the current mount options:

UUID=3D46fc675c-f196-4be2-bf4d-461d473de6b1 / ext4
errors=3Dremount-ro,user_xattr 0 1

And the dmesg messages I get are:

[    2.908858] EXT4-fs (sda5): mounted filesystem with ordered data
mode. Opts: (null)
[   14.167465] EXT4-fs (sda5): re-mounted. Opts: errors=3Dremount-ro,us=
er_xattr
[   15.512701] EXT4-fs (sda5): re-mounted. Opts:
errors=3Dremount-ro,user_xattr,commit=3D0
[   20.801609] EXT4-fs (sda5): re-mounted. Opts:
errors=3Dremount-ro,user_xattr,commit=3D0

How can I give you more information?

Thanks,
  Javi

On Wed, Feb 16, 2011 at 2:12 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Was=C2=A0ext4 mounted with dealloc?
>
> On Mon, Feb 7, 2011 at 3:41 PM, Javi <javier.cabezas@gmail.com> wrote=
:
>>
>> I am developing a software based DSM. In order to avoid concurrent
>> updates on a memory page that is being updated by the runtime I am
>> using a shadow mapping to perform the updates. This mappings are
>> created by opening a file, unlinking it and mmap-ing on the file
>> descriptor. Everything is working but I am experiencing heavy disk I=
/O
>> during execution on a machine with a single ext4 file system. Other
>> machines that use ext3 partitions don't exhibit this behavior (there
>> is no disk I/O at all). This machine is using the kernel version
>> 2.6.35-25-generic.
>>
>> The exact steps performed to create the mappings are:
>>
>> =C2=A0 =C2=A0// Create the file
>> =C2=A0 =C2=A0snprintf(tmp, FILENAME_MAX, "/tmp/testXXXXXX");
>> =C2=A0 =C2=A0int fd =3D mkstemp(tmp);
>> =C2=A0 =C2=A0if(fd < 0) return NULL;
>> =C2=A0 =C2=A0unlink(tmp);
>>
>> =C2=A0 =C2=A0if(ftruncate(fd, count) < 0) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
>> =C2=A0 =C2=A0}
>> =C2=A0 =C2=A0...
>>
>> =C2=A0 =C2=A0// Create a mapping
>> =C2=A0 =C2=A0addr =3D mmap(NULL, count, PROT_READ | PROT_WRITE, MAP_=
SHARED, fd, 0);
>>
>>
>> Does ext4 write to mmap'ed files although they don't have a name in
>> the file system? Am I doing anything wrong?
>>
>> Thanks,
>> =C2=A0Javi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>
>



--=20
Javi
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
