From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Tue, 09 Feb 2010 16:53:05 +0300
Message-ID: <87sk9awm66.fsf@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
	<87f94c371002081554k3e4d6019q332602fea344ccc9@mail.gmail.com>
	<874olqpvtt.fsf@openvz.org>
	<87f94c371002090536v2450e67dlb77fa70bfc46cec0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:52922 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0BINxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 08:53:10 -0500
Received: by bwz23 with SMTP id 23so154911bwz.1
        for <linux-ext4@vger.kernel.org>; Tue, 09 Feb 2010 05:53:08 -0800 (PST)
In-Reply-To: <87f94c371002090536v2450e67dlb77fa70bfc46cec0@mail.gmail.com>
	(Greg Freemyer's message of "Tue, 9 Feb 2010 08:36:38 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer <greg.freemyer@gmail.com> writes:

> On Tue, Feb 9, 2010 at 5:06 AM, Dmitry Monakhov <dmonakhov@openvz.org=
> wrote:
>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>
>>> On Mon, Feb 8, 2010 at 8:28 AM, Dmitry Monakhov <dmonakhov@openvz.o=
rg> wrote:
>>>> * Abstract
>>>> =C2=A0A subtree of a directory tree T is a tree consisting of a di=
rectory
>>>> =C2=A0(the subtree root) in T and all of its descendants in T.
>>>>
>>>> =C2=A0Subtree feature allows to create an isolated (from user poin=
t of view)
>>>> =C2=A0trees.
>>>>
>>>> =C2=A0Subtree assumptions:
>>>> =C2=A0(1) Each inode has subtree id. This id is persistently store=
d inside
>>>> =C2=A0 =C2=A0 =C2=A0inode (xattr, usually inside ibody)
>>>> =C2=A0(2) Subtree id is inherent from parent directory
>>>> =C2=A0(3) Inode can not belongs to different subtree
>>>> =C2=A0 =C2=A0 =C2=A0Otherwise changes in one subtree result in cha=
nges in other subtree
>>>> =C2=A0 =C2=A0 =C2=A0which contradict to isolation criteria.
>>>>
>>>> =C2=A0This feature is similar to project-id in XFS. One may assign=
 some id to
>>>> =C2=A0a subtree. Each entry from the subtree may be accounted in d=
irectory
>>>> =C2=A0subtree quota. Will appear in later patches.
>>>>
>>>> * Disk layout
>>>> =C2=A0Subtree id is stored on disk inside xattr usually inside ibo=
dy.
>>>> =C2=A0Xattr is used only as a data storage, It has not user visiab=
le xattr
>>>> =C2=A0interface.
>>>>
>>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>>
>>> Dmitry,
>>>
>>> I think the idea of subtrees is useful, but I'm curious about other
>>> use cases than just quota.
>>>
>>> At first glance you are attempting to create a generic subtree
>>> functionality for ext4, but criteria 3) above says a inode can only=
 be
>>> in one subtree at a time.
>> Theoretically this is possible, but this dramatically complicate thi=
ngs
>> Just think about this. If inode belongs to different subtrees then
>> it must have several tree-dquota objects attached to it. This means
>> that quota require great quota redesign.
>> Obviously i don't know any use case for this feature. do you know an=
y?
>
> Maybe we're talking about different things.  I working with the OHSM
> project <http://ohsm.sourceforge.net/>
>
> We haven't submitted any patches yet, but for one of our features we
> have something fairly close to your subtree patch.  If we were to
> leverage your patch and drop that part of ours we would be in the
> unhappy situation that quota and ohsm could not both be enabled on th=
e
> same filesystem because the ohsm subtree geography is not likely to b=
e
> consistent with the quota subtree geography.
>
> If we call quota and ohsm services then my desire would be to see you=
r
> subtree patches support orthoganal subtree groups.  One group per
> service.
>
> I haven't looked into the actual implementation, but from an API
> perspective it is just a matter of adding a service parameter to the
> various calls.  For a given subtree service group, a given inode coul=
d
> only be part of one subtree, but a single inode could participate in
> multiple subtree service groups.
Ok now i think i understand what you are talking about.
one subtree <=3D> one service is the main rule i'm standing.
If you wan to support several services, no problem
I can easily extend xattr to support different services
something like this
subtree_entry
{
        __le16 sbe_flags /* entry flags */
        __le16 sbe_type  /* service type */
        __le32 sbe_id    /* subtree id */
}
/* subtree entry flags
enum {
     SUBTREE_FL_VALID           =3D 1, /* entry contains valid data */
     SUBTREE_FL_INHERENT        =3D 2, /* inherent id from parent on
                                                            create *
     SUBTREE_FL_ISOLATE         =3D 4  /* Isolated subtree */
    /* and soon */
};

>
> Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
