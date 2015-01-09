From: Pranay Srivastava <pranjas@gmail.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Sat, 10 Jan 2015 01:01:19 +0530
Message-ID: <CA+aCy1Esm-2NGvJFG4_22rNaXiOqx1f2beCPpSCcovrXFf07+A@mail.gmail.com>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
	<20150109035123.GG22149@ZenIV.linux.org.uk>
	<20150109120159.GA20300@stefanha-thinkpad.redhat.com>
	<alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, kzak@redhat.com,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

On Fri, Jan 9, 2015 at 9:22 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redha=
t.com> wrote:
> On Fri, 9 Jan 2015, Stefan Hajnoczi wrote:
>
>> Date: Fri, 9 Jan 2015 12:01:59 +0000
>> From: Stefan Hajnoczi <stefanha@redhat.com>
>> To: Al Viro <viro@ZenIV.linux.org.uk>
>> Cc: Dexuan Cui <decui@microsoft.com>,
>>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
>>     'linux-ext4' <linux-ext4@vger.kernel.org>
>> Subject: Re: Can one file system be R/W mounted multiple times in Li=
nux?
>>
>> On Fri, Jan 09, 2015 at 03:51:23AM +0000, Al Viro wrote:
>> > On Fri, Jan 09, 2015 at 03:44:16AM +0000, Dexuan Cui wrote:
>> > > The 'mount' utility allows me to mount 1 file systems multiple t=
imes at different
>> > > mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".
>> > >
>> > > I tried to write from /a and /b at the same time and it seems ev=
erything is OK
>> > > and no data corruption happens.
>> > > I tried only  ext4 only.
>> > >
>> > > Can somebody please tell me if this usage is safe?
>> >
>> > Yes.
>>
>> Can you explain under what conditions mounting the same file system
>> twice will work?
>>
>> I guess the kernel is looking up the block device and then sharing t=
he
>> superblock if the file system is already mounted on this block devic=
e?
>>
>> If I use two loop devices for the same underlying storage it does no=
t
>> work:
>>
>>   # mount -o loop /var/tmp/ext4.img /tmp/a
>>   # mount -o loop /var/tmp/ext4.img /tmp/b
>
> Because now you have two block devices backed by the same file.
> Which as Christoph pointed out is equivalent of accessing it from
> two different systems.
>
> What you probably want to do is this:
>
> # losetup --show -f /var/tmp/ext4.img
> /dev/loop0
>
> mount /dev/loop0 /tmp/a
> mount /dev/loop0 /tmp/b
>
> Now the question is, whether 'mount' can be a bit smarter than that
> and just mount the already existing block device instead of creating
> new one ? Karel ?

It's not the mount. If you see mount_bdev it checks for this and uses
the existing super block from the first mount
for all subsequent mounts of that block device.

When block devices differ, as in with 2 loop devices they have
different bdev and that's why it doesn't work with 2
loop devices.

>
> -Lukas
>
>
>>   # touch /tmp/a/a
>>   # ls /tmp/b
>>   lost+found
>>   # umount /tmp/a
>>   # umount /tmp/b
>>   # mount -o loop /var/tmp/ext4.img /tmp/a
>>   [1078357.297245] EXT4-fs error (device loop0): ext4_lookup:1441: i=
node #2: comm ls: deleted inode referenced: 12
>>
>> Stefan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
        ---P.K.S
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
