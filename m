From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: delayed extent tree test cases
Date: Fri, 9 Mar 2012 17:19:43 +0800
Message-ID: <CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com>
	<CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com>
	<4F59A599.4050400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34639 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab2CIJTo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 04:19:44 -0500
Received: by obbuo6 with SMTP id uo6so1882259obb.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Mar 2012 01:19:43 -0800 (PST)
In-Reply-To: <4F59A599.4050400@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Alrighty, I'll give it a run through xfstests tonight, and then maybe=
 I can
> show you what I've got so far. =A0My first few patches are pretty muc=
h just
> renaming things from delayed_extent to status_extent, sense it's doin=
g a lot
> more than delayed extents now. =A0I figured those patches we could ju=
st merge
> together sense I dont think your set has been merged yet.
Agree!  This can reduce Ted's work.

>
> The next step that I am working on now is getting it to track allocat=
ed
> extents. =A0So any pointers for doing that would be helpful :) =A0It =
looks like
> the current code is optimized for merging extents as much as possible=
, and
> that makes sense for delayed extents, but for allocated extents, we n=
eed to
Yep, it is optimized much for delayed extents.
> get it to mirror the existing extents. =A0That way we will know what =
extents
> there are to lock before we start doing things with the current exten=
t tree.
>
> When I think about all the ins and outs of trying to keep the trees i=
n sync,
Actually, delayed extents is also synced.  This can be easily achieved
by protecting operations on extent tree by i_data_sem.

> I realize it may get complex, but I dont think we would want to deal =
with
> the odd things that might come out of allowing tasks to lock a partia=
l
> extent either. =A0Suggestions for simplifications are certainly welco=
me though
> :)
I am a little confused by partial extent here.  I am guessing you
meant extent rb-tree in memory is the mirror of extent tree in inode
which is stored on disk.  Am I right?

In my head, the extent tree used by extent lock traces logical
extents, for example, a process locks a range of a file and it does
not care the physical blocks.    So we just need to record logical
extent without physical blocks infos.  Then locking on an extent may
trigger splitting on an extent while unlocking may trigger merging on
extents.  Am I right?

Yongqiang.


>
> Thx!
> Allison Henderson
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
