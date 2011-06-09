From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 13:54:13 +0300
Message-ID: <BANLkTin0RKZbDmB1movombH9o4HDpTnvFw@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>
	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>
	<alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
	<BANLkTikUXdvMQROYEdxnyfcPuB0e9ozMOg@mail.gmail.com>
	<BANLkTinU9Hegr3iA5it2vNjE_RYbB+8+RQ@mail.gmail.com>
	<BANLkTik9Mnq5yqK795pxyr8SK-3EOzzNhA@mail.gmail.com>
	<alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
	<BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
	<alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52813 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1FIKyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 06:54:16 -0400
In-Reply-To: <alpine.LFD.2.00.1106091012030.4138@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 9, 2011 at 11:46 AM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> On Thu, 9 Jun 2011, Amir G. wrote:
>
>> On Thu, Jun 9, 2011 at 9:50 AM, Lukas Czerner <lczerner@redhat.com> =
wrote:
>> > On Thu, 9 Jun 2011, Yongqiang Yang wrote:
>> >
>> >> On Thu, Jun 9, 2011 at 11:18 AM, Amir G. <amir73il@users.sourcefo=
rge.net> wrote:
>> >> > On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gma=
il.com> wrote:
>> >> >>> But I do understand the difference. And also, when it comes t=
o fs level
>> >> >>> snapshotting I would suspect that it would do something we ca=
n not do
>> >> >>> with the current solutions, for example per-file or per-direc=
tory snapshots,
>> >> >>> cat ext4 snapshots do that ?
>> >> >> Hi Lukas,
>> >> >>
>> >> >> I noticed that there is no answer to this question in the thre=
ad. =A0I
>> >> >
>> >> > I think I answered this question with No it can't ;-)
>> >> I think this can be implemented easily by chattr and adding check=
 in
>> >> should_snapshot() or should_move_data().
>> >>
>> >> And I thought Lukas are focusing on if ext4-snapshots can do this
>> >> easily. =A0So i said YES:-)
>> >
>> > Cool, finally something interesting :). So, how it'll work ? Does =
that
>> > require any format changes again:) ? Can you exclude the whole roo=
t and
>> > then selectively pick the directories or files you are interested =
in ?
>>
>> The design is actually very simple and not as powerful as you
>> probably desire.
>> I hate to get into the design of future features, when we haven't
>> even ACKed the current feature yet, but since you're the only one
>> did any review, I owe you that much ;-)
>
> Thanks Amir!
>
> You have to understand that I am still not convinced that ext4 snapsh=
ot
> in its current state is really what we want to have in ext4. Especial=
ly
> given the very basic features it provides, without any knowledge on h=
ow
> it can be extended (but you're slowly providing that information, so
> thanks for that). And especially facing the new dm-multisnap, I reall=
y
> wonder if it is worth it.

Did you not see my post on LVM vs. Ext4 snapshots?
https://lkml.org/lkml/2011/6/8/296
dm-multisnap is much better than dm-snap, but it's not perfect.
And ext4 snapshots aren't perfect either, but they do bring some
new interesting options for sys admins.

>
> If we want filesystem level snapshotting we can try to do it right wi=
th
> all the benefits that snapshots on that level brings. But what I see
> now, is not even remotely the case. And I have the feeling that all t=
he
> features that might be interesting for snapshotting at file system
> level, are just a hack and not inherent from the design. But that is
> probably because your goal was to snapshot the whole filesystem for t=
he
> backup purposes, but that's not what I would expect from fs level
> snapshots. I really hope you understand my point.
>

I think I understand the point. The reason that ext4 snapshots are
less powerful then, say, btrfs snapshots, is not because of my design,
it is because I was building on top a 20 year old on-disk format (ext2)=
, which
was extended 2 times already, but remained mostly backwards compatible.
There is only so much you can do without block reference counts and thi=
s
is all that I was trying to do.


>>
>> To exclude a file from snapshot it needs to have the NOCOW_FL flag.
>> Ironically, btrfs have already added that flag in parallel to me (fo=
r the
>> same purpose) so the flag it is already reserved in the code :-)
>>
>> To avoid some transition issues and keep it really simple,
>> I disallow changing the NOCOW_FL
>> for regular file and only allow to change it for directories.
>> The NOCOW_FL is inherited from the parent directory,
>> so setting/clearing the flag on a directory means:
>> "All files/subdirs will be created excluded/not-excluded from now on=
".
>>
>> Inside the snapshot image, excluded directories, which are not reall=
y
>> excluded, show normally, but excluded files are shown with zero leng=
th,
>> because making the files disappear is hard, but their blocks may hav=
e already
>> been reused, so we cannot allow access to them.
>>
>> >
>> > How does rollback work with ext4 snapshots ? Can you selectively r=
oll
>> > back one file, or the whole directory subtree even when you're
>> > snapshotting more ?
>>
>> So there is actually no inherent "rollback" feature, not for a file/=
dir
>> and not for the entire fs.
>> It's a drawback of ext4 snapshots, but hey, cp/rsync from snapshot
>> still works for file/dir ;-)
>> As for full "fs" rollback. A revert tool has been developed (by stud=
ents),
>> which requires an external storage to export the "revert patch".
>> This tool is going to be enhanced to use LVM snapshot storage
>> and LVM --merge option to implement ext4 "revert to snapshot" with Y=
um.
>
> And that is the problem. Because at this level you should be able to =
do
> it without very much trouble, because being at file system level you
> should have all the information. Do not get me wrong, I am not saying
> that this is easy, but is should be "from design". Exporting the
> "revert patch" to the external storage, or exporting snapshot to LVM
> format to be able to merge it...that is all just hacks, because the
> design itself does not count with that possibility.
>

The design makes a conscious choice to keep snapshots *inside*
the filesystem.
This is both an advantage (no need to change on-disk format and checkin=
g tools)
and disadvantage (you cannot mount a snapshot without mounting the fs f=
irst).


>>
>> >
>> > You see, when it comes to the full fs snapshots I am not convinced=
 that
>> > it is *very* useful, yes it might have some users, but you can alw=
ay
>> > take the safe way and do lvm snapshots (or better use the new mult=
isnap)
>> > for backup, without need to modify stable filesystem code.
>> >
>>
>> You think like a developer. Try talking to some sys admins.
>> Especially ones that worked with Solaris/ZFS or NetApp.
>> See what they think about snapshots and about the LVM alternative...
>> Snapshots have addictive qualities. Ones you've used them, you can't
>> go back to not having them.
>> Imagine how people used to live before the 'Undo' button and imagine
>> that your employer forced you to use an editor without an Undo butto=
n.
>> This is the kind of feedback I got from sys admins that moved from S=
olaris
>> to Linux.
>
> Exactly, so if we want fs level snapshots, it should use that
> privilege no hack its way to do things like roll back, or
> excludes+includes. Ext4 was not meant to work that way, nor was your
> snapshots designed to work that way. If we are considering backups on=
ly,
> because that is what you ext4 snaphosts can provide now, I would pref=
er
> to use LVM. But yes, we all need to know how the new multisnap works
> out.
>

Why do you keep saying 'backup only'?
There is a huge difference between having long lived snapshots,
like CTERA products have, and temporary snapshot for backup
purpose (for which LVM is adequate).

>>
>>
>> > Also, I do not buy the whole argument of "not have to create separ=
ate disk
>> > space for snapshot". It is actually better for sysadmins, because =
you
>> > have perfect control on what is going on, how much space is used f=
or
>> > your snapshots and how much is used by your data. You can always e=
asily
>> > extend the snapshot volume, or let it die silently when it is too =
old
>> > and too big.
>> >
>>
>> Seriously, Lukas, talk to sys admins.
>> Letting the snapshot die silently is the worst possible thing that a=
 snapshots
>> implementation can do (for long lived snapshots).
>
> Oh, no you misunderstood. Even with your snapshots you'll have to del=
ete
> old snapshots someday, because otherwise you'll run out of space. Wit=
h
> LVM however, you have prereserved space for it, so even if your snaps=
hot
> volume gets full, it does not affect your filesystem what so ever. An=
d,
> as a administrator, you can decide whether to extend the snapshot vol=
ume
> to let it live longer, or just let it be and it will die eventually.
>
> And, as far as I know, the new multisnap will notify the admin when t=
he
> snapshot volume approaches the watermark the same way that for exampl=
e
> thinly provisioned storage would do. But again, with your snapshots i=
t
> will give you ENOSPC when the snapshot grow too big, and at the end
> of the day, you need to create data to be able to backup it:), so hav=
ing
> snapshots separate from your fs volume makes sense.
>

Yes, one day you will run out of space and will be getting a warning
before that, if you are using a CTERA product.
You won't be getting the warning from the kernel snapshots code, but fr=
om
disk space monitoring daemon.
And when you get the warning (or ENOSPC if you ignored the warnings)
you will have 2 options:
1. add disks and resize the fs
2. delete some snapshots

When using a CTERA product, you not have to pre-partition your disk
space between fs and snapshots - they are thinly provisioned, which
is a big advantage for a product which does not require being an IT exp=
ert to
operate it.


>>
>>
>> > How does it actually work on ext4 snapshots ? When you're going to
>> > rewrite a file, you will never know how much disk space it'll take=
 in
>> > advance, am I right ? Is the filesystem accounting for the snapsho=
t size
>> > as well ? or is it hidden ?
>>
>> It's not hidden, it's accounted for as a regular file (usually owned=
 by root).
>> You need a bit of scripting to gather the disk space used by snapsho=
ts (du).
>>
>> In ANY snapshots implementation, you can get ENOSPC on operations,
>> which traditionally could not produce this error.
>> This statement is also true for thin provisioning implementations.
>> The question is how the implementation handles these situations.
>>
>> What I came to realize on LSF, is that my implementation is the only
>> one (of LVM and btrfs) that tries to deal with the ENOSPC issue and
>> does a good job most of the time.
>>
>> I deal with it by reserving space for metadata COW on snapshot
>> take, so if a future ENOSPC during metadata COW is possible,
>> snapshot take will fail with ENOSPC.
>>
>> As for ENOSPC during regular file rewrite, that's not such a big pro=
blem.
>> The application simply gets ENOSPC as if the file was sparse to begi=
n
>> with. It may not be pleasant if the application have fallocated the =
space
>> and used mmap/close without msync...
>> The only way I see around this issue is reserving space on mmap time
>> (and returning ENOSPC at that time), but again, this issue is shared
>> with btrfs, but is easier to fix (I think) with ext4 snapshots.
>
> Yes, I do understand that ext4 snaphosts are doing well in that aspec=
t,
> but as I said, having snapshots separate from your file system gives
> you advantage of not running into ENOSPC on your file system until yo=
u
> really fill it with data.

It should be, as David wrote, a choice to the sys admin.
Because ext4 snapshots are thinly provisioned, you can always say
"use 10% for snapshots and 90% for data" (like you would with LVM),
But you cannot say "reserve 10% for snapshots 50% for data and the
rest to either" when you administer LVM snapshots.

You are confusing user functionality with functionality provided by the=
 kernel.
LVM happens to check water marks in the kernel because of it's design.
That doesn't mean that the same thing cannot be accomplished for ext4
snapshots by user tools.


>
> Granted, I have to take a look at the multisnap code, to see what it =
can
> do and compare it with ext4 snapshots, because really, if it is good
> enough and you will be able to do snapshotting backups as you do with
> your approach, I do not see the reason why to complicate our life in
> ext4.
>

I don't know how you intend to determine if dm-multisnap is 'good enoug=
h'.
I don't claim to have the capability myself to determine if ext4 snapsh=
ots
are 'good enough'.
I just try to present the technical differences between the 3 solutions
(LVM,ext4,btrfs) and claim that each have their advantages and disadvan=
tages
over others.
I wish more sys admins and end users would provide feedback, though I d=
on't
know how many of them are following LKML.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
