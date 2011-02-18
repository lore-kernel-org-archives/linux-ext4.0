From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH,RFC 7/7] ext4: move ext4_journal_start/stop to mpage_da_map_and_submit()
Date: Fri, 18 Feb 2011 19:44:04 +0800
Message-ID: <AANLkTinskmSaOuC=QS5a3OA0oTYMx7N5u+4sJjLLO59W@mail.gmail.com>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
	<1297556157-21559-8-git-send-email-tytso@mit.edu>
	<20110218042353.GA4923@thunk.org>
	<AANLkTikj0Vy=MQjtLERQ0RGzbQQVjjzdX4jbqB3QsuLU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49973 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1BRLoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Feb 2011 06:44:06 -0500
Received: by ewy5 with SMTP id 5so1495443ewy.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Feb 2011 03:44:04 -0800 (PST)
In-Reply-To: <AANLkTikj0Vy=MQjtLERQ0RGzbQQVjjzdX4jbqB3QsuLU@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 18, 2011 at 6:42 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
>
> On Fri, Feb 18, 2011 at 6:23 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Sat, Feb 12, 2011 at 07:15:57PM -0500, Theodore Ts'o wrote:
> >> Previously, ext4_da_writepages() was responsible for calling
> >> ext4_journal_start() and ext4_journal_stop(). =A0If the blocks had
> >> already been allocated (we don't support journal=3Ddata in
> >> ext4_da_writepages), then there's no need to start a new journal
> >> handle.
> >>
> >> By moving ext4_journal_start/stop calls to mpage_da_map_and_submit=
()
> >> we should significantly reduce the cpu usage (and cache line bounc=
ing)
> >> if the journal is enabled. =A0This should (hopefully!) be especial=
ly
> >> noticeable on large SMP systems.
> >>
> >> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> >
> > Argh, it turns out this doesn't work. =A0I was getting sporadic
> > deadlocks and I finally figured out the problem. =A0If a process is
> > holding page locks, it can't call ext4_journal_start() safely in
> > data=3Dordered, since there's a chance that there won't be enough
> > transaction credits and a new transaction will be started. =A0And a=
t
> > that point, in data=3Dordered mode, we may end up calling
> > journal_submit_inode_data_buffers(), which could try to write back =
the
> > inode pages in question --- which are already locked.
> >
> > This means that we need to start the journal handle long before we
> > know whether or not we really need it. =A0Boo, hiss!
> >
> > The only way to solve this problem is to do what I've been planning
> > all for a while, which is to add support in ext4_map_blocks() for a
> > mode where it will allocate a region of blocks, but *not* update th=
e
> > extent map. =A0It will have to store the allocation in an in-memory
> > cache, so that if other CPU's try to request a logical block, it wi=
ll
> > get the right answer. =A0However, the actual on-disk extent map can=
't be
> > updated until *after* the data is safely written on disk (and the
> > pages can thus be unlocked).
> >
> > Once we do that, we'll also be able to ditch ordered mode for good,
> > since it means that there won't be any chance of stale data being
> > revealed, without any of performance disasters involved with
> > data=3Dordered mode.
> >
> > I have no idea what these changes will do to Amir's snapshot plans,
> > but sorry, getting this right is going to be higher priority.
>
> If anything, memory-only data allocations would be a great contributi=
on
> to extent data move-on-write :-)
>
> It would allow me to split the extent in-memory and defer the decisio=
n,
> whether to split the extent on-disk or wait for copy-on-write to comp=
lete,
> to data writeback time.
>
> By that time, async copy-on-write sequence may have already completed
> and fragmentation can be avoided.
>
> If you are looking for someone to execute your plan, or write some
> experimental code, I think that Yongqiang would be up for the task
> (hope that's OK with Yongqiang)
No problem with me.
>
> >
> > I may end up submitting the rest of this patch series without this
> > last patch, since it does clean up the code paths a lot, and it sho=
uld
> > result in a few small performance improvements --- the big performa=
nce
> > improvement, found in this patch, we'll have to skip until we can f=
ix
> > up the writeback submission.
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 - Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >



--
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
