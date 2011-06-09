From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Thu, 9 Jun 2011 10:57:11 +0300
Message-ID: <BANLkTi=fugrRE0P5m8nMPrH_kZqPZB7ajA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51061 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1FIH5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 03:57:13 -0400
In-Reply-To: <alpine.LFD.2.00.1106090834270.4138@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 9, 2011 at 9:50 AM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Thu, 9 Jun 2011, Yongqiang Yang wrote:
>
>> On Thu, Jun 9, 2011 at 11:18 AM, Amir G. <amir73il@users.sourceforge=
=2Enet> wrote:
>> > On Thu, Jun 9, 2011 at 4:59 AM, Yongqiang Yang <xiaoqiangnk@gmail.=
com> wrote:
>> >>> But I do understand the difference. And also, when it comes to f=
s level
>> >>> snapshotting I would suspect that it would do something we can n=
ot do
>> >>> with the current solutions, for example per-file or per-director=
y snapshots,
>> >>> cat ext4 snapshots do that ?
>> >> Hi Lukas,
>> >>
>> >> I noticed that there is no answer to this question in the thread.=
 =A0I
>> >
>> > I think I answered this question with No it can't ;-)
>> I think this can be implemented easily by chattr and adding check in
>> should_snapshot() or should_move_data().
>>
>> And I thought Lukas are focusing on if ext4-snapshots can do this
>> easily. =A0So i said YES:-)
>
> Cool, finally something interesting :). So, how it'll work ? Does tha=
t
> require any format changes again:) ? Can you exclude the whole root a=
nd
> then selectively pick the directories or files you are interested in =
?

The design is actually very simple and not as powerful as you
probably desire.
I hate to get into the design of future features, when we haven't
even ACKed the current feature yet, but since you're the only one
did any review, I owe you that much ;-)

To exclude a file from snapshot it needs to have the NOCOW_FL flag.
Ironically, btrfs have already added that flag in parallel to me (for t=
he
same purpose) so the flag it is already reserved in the code :-)

To avoid some transition issues and keep it really simple,
I disallow changing the NOCOW_FL
for regular file and only allow to change it for directories.
The NOCOW_FL is inherited from the parent directory,
so setting/clearing the flag on a directory means:
"All files/subdirs will be created excluded/not-excluded from now on".

Inside the snapshot image, excluded directories, which are not really
excluded, show normally, but excluded files are shown with zero length,
because making the files disappear is hard, but their blocks may have a=
lready
been reused, so we cannot allow access to them.

>
> How does rollback work with ext4 snapshots ? Can you selectively roll
> back one file, or the whole directory subtree even when you're
> snapshotting more ?

So there is actually no inherent "rollback" feature, not for a file/dir
and not for the entire fs.
It's a drawback of ext4 snapshots, but hey, cp/rsync from snapshot
still works for file/dir ;-)
As for full "fs" rollback. A revert tool has been developed (by student=
s),
which requires an external storage to export the "revert patch".
This tool is going to be enhanced to use LVM snapshot storage
and LVM --merge option to implement ext4 "revert to snapshot" with Yum.

>
> You see, when it comes to the full fs snapshots I am not convinced th=
at
> it is *very* useful, yes it might have some users, but you can alway
> take the safe way and do lvm snapshots (or better use the new multisn=
ap)
> for backup, without need to modify stable filesystem code.
>

You think like a developer. Try talking to some sys admins.
Especially ones that worked with Solaris/ZFS or NetApp.
See what they think about snapshots and about the LVM alternative...
Snapshots have addictive qualities. Ones you've used them, you can't
go back to not having them.
Imagine how people used to live before the 'Undo' button and imagine
that your employer forced you to use an editor without an Undo button.
This is the kind of feedback I got from sys admins that moved from Sola=
ris
to Linux.


> Also, I do not buy the whole argument of "not have to create separate=
 disk
> space for snapshot". It is actually better for sysadmins, because you
> have perfect control on what is going on, how much space is used for
> your snapshots and how much is used by your data. You can always easi=
ly
> extend the snapshot volume, or let it die silently when it is too old
> and too big.
>

Seriously, Lukas, talk to sys admins.
Letting the snapshot die silently is the worst possible thing that a sn=
apshots
implementation can do (for long lived snapshots).


> How does it actually work on ext4 snapshots ? When you're going to
> rewrite a file, you will never know how much disk space it'll take in
> advance, am I right ? Is the filesystem accounting for the snapshot s=
ize
> as well ? or is it hidden ?

It's not hidden, it's accounted for as a regular file (usually owned by=
 root).
You need a bit of scripting to gather the disk space used by snapshots =
(du).

In ANY snapshots implementation, you can get ENOSPC on operations,
which traditionally could not produce this error.
This statement is also true for thin provisioning implementations.
The question is how the implementation handles these situations.

What I came to realize on LSF, is that my implementation is the only
one (of LVM and btrfs) that tries to deal with the ENOSPC issue and
does a good job most of the time.

I deal with it by reserving space for metadata COW on snapshot
take, so if a future ENOSPC during metadata COW is possible,
snapshot take will fail with ENOSPC.

As for ENOSPC during regular file rewrite, that's not such a big proble=
m.
The application simply gets ENOSPC as if the file was sparse to begin
with. It may not be pleasant if the application have fallocated the spa=
ce
and used mmap/close without msync...
The only way I see around this issue is reserving space on mmap time
(and returning ENOSPC at that time), but again, this issue is shared
with btrfs, but is easier to fix (I think) with ext4 snapshots.




>
> Thanks!
> -Lukas
>
>>
>> >
>> >> can give the question the answer that ext4 can snapshot per-file =
or
>> >> per-directory, and can exclude some files or directories from bei=
ng
>> >> snapshotted.
>> >>
>> >
>> > So the full answer is that ext4 snapshot CAN exclude
>> > certain files/dirs from snapshot, but this feature is not fully im=
plemented yet
>> > (I have it in a dev branch)
>> >
>> >> --
>> >> Best Wishes
>> >> Yongqiang Yang
>> >>
>> >
>>
>>
>>
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
