From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: Question about writable ext4-snapshot
Date: Sun, 22 Jan 2012 11:31:31 +0800
Message-ID: <CAFZ0FUXK89LLOmRGuXWW1UAZo0ydTi_O=383E+nsCywQgYh6eQ@mail.gmail.com>
References: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
	<92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
	<CAOQ4uxgUFqYeCWiuHn+jXSS0bD=8u1aM5ujcd9BRdpMJtHeFdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Tao Ma <taoma.tm@gmail.com>,
	coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40701 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2AVDbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Jan 2012 22:31:32 -0500
Received: by obcva7 with SMTP id va7so2013851obc.19
        for <linux-ext4@vger.kernel.org>; Sat, 21 Jan 2012 19:31:32 -0800 (PST)
In-Reply-To: <CAOQ4uxgUFqYeCWiuHn+jXSS0bD=8u1aM5ujcd9BRdpMJtHeFdQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/1/22 Amir Goldstein <amir73il@gmail.com>:
> On Sat, Jan 21, 2012 at 6:24 AM, Theodore Tso <tytso@mit.edu> wrote:
>>
>> On Jan 20, 2012, at 9:45 PM, Robin Dong wrote:
>>
>>> Hello, Amir
>>>
>>> I am evaluating ext4-snapshot (on github) for TAOBAO recently. The
>>> snapshot of an ext4 fs is READONLY now, but we do need to write dat=
a
>>> into snapshot.
>>> We also want using =A0ext4-snapshot to do online-fsck on
>>> Hadoop clusters, but our hadoop clusters are using no-journal ext4
>>> now. So we have some question
>>>
>>> 1. Will it be possible to implement a writable ext4-snapshot ?
>>> 2. Will it be possible to snapshot a no-journal ext4-fs ?
>>> 3. What's the difficult point of =A0implementing above ?
>>
>
> Hello Robin,
>
> 1. writable snapshots (snapshot clones) are actually quite simple to =
implement
> (a sparse file containing all changes from a read-only snapshot).
> The real challenge is how to support snapshots of these clones and ho=
w to
> implement the space reclaim efficiently (time wise) when deleting sna=
pshots.
> indeed, LVM thin-provisioning target handles space reclaim very effic=
iently.
>
> 2. I think it is possible, but I never looked into it, so there may
> be challenges that I haven't foreseen.
> The obvious culprit is that snapshots will not be reliable after cras=
h.
> JBD ensures that metadata is not overwritten on-disk before it is
> copied to snapshot,
> but without journal, after a crash, meta data could have already been
> written and you loose
> the origin data that was supposed to be copied to snapshot.
>
> 3. I think I have already answered that question above, but the actua=
l
> difficulty
> really depends on your specific needs.
>
>> Something else to consider is that the device mapper thin-provisioni=
ng approach. =A0 This approach does the snapshotting at the device-mapp=
er layer, which means it is separate from the file system. =A0It relies=
 on using the discard request when the file is unlinked to know when bl=
ocks can be released from the snapshot. =A0It also uses a granularity m=
uch smaller than that of the traditional LVM-style snapshots.
>>
>> This code will still need a few months to be mature (the thin-provis=
ioning code just got merged into 3.2, but discard support isn't done ye=
t, and the userspace support is lagging). =A0 But in the long run, this=
 might be a very attractive way of providing multiple levels of writeab=
le snapshots, in a clean and relatively simple way.
>>
>
> There are some lengthy threads about LVM thinp vs. Ext4 snapshots her=
e:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/25968/focus=3D26=
056
> and here:
> http://thread.gmane.org/gmane.comp.file-systems.ext4/26041
>
> At the end of the day, thinp target is a very powerful tool, but is
> does not fit all
> use cases. In particular, it fragments the on-disk layout of ext4 met=
adata and
> benchmark results for how this affect performance were never publishe=
d.
>
> Also, thinp needs to store quite a lot of metadata for the mapping of
> all thinp blocks
> and in order to keep this metadata durable and not hurt write speed p=
erformance
> you will almost certainly need to store this metadata on an SSD - not
> a bad solution
> for a high end server, but not sure if everyone can afford this.
>
> Amir.

Thanks for all your suggestion!
I will evaluate thin-provision and ext4-snapshot both later.

--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
