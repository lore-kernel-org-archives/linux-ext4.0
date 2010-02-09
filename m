From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Tue, 09 Feb 2010 17:48:10 +0300
Message-ID: <87ljf2wjmd.fsf@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
	<87f94c371002081554k3e4d6019q332602fea344ccc9@mail.gmail.com>
	<874olqpvtt.fsf@openvz.org>
	<87f94c371002090536v2450e67dlb77fa70bfc46cec0@mail.gmail.com>
	<87sk9awm66.fsf@openvz.org>
	<87f94c371002090629l6e496b23w8eeb7bbdf3e9b1fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:57494 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0BIOsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 09:48:15 -0500
Received: by bwz23 with SMTP id 23so218467bwz.1
        for <linux-ext4@vger.kernel.org>; Tue, 09 Feb 2010 06:48:13 -0800 (PST)
In-Reply-To: <87f94c371002090629l6e496b23w8eeb7bbdf3e9b1fe@mail.gmail.com>
	(Greg Freemyer's message of "Tue, 9 Feb 2010 09:29:43 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer <greg.freemyer@gmail.com> writes:

> On Tue, Feb 9, 2010 at 8:53 AM, Dmitry Monakhov <dmonakhov@openvz.org=
> wrote:
>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>
>>> On Tue, Feb 9, 2010 at 5:06 AM, Dmitry Monakhov <dmonakhov@openvz.o=
rg> wrote:
>>>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>>>
>>>>> On Mon, Feb 8, 2010 at 8:28 AM, Dmitry Monakhov <dmonakhov@openvz=
=2Eorg> wrote:
>>>>>> * Abstract
>>>>>> =C2=A0A subtree of a directory tree T is a tree consisting of a =
directory
>>>>>> =C2=A0(the subtree root) in T and all of its descendants in T.
>>>>>>
>>>>>> =C2=A0Subtree feature allows to create an isolated (from user po=
int of view)
>>>>>> =C2=A0trees.
>>>>>>
>>>>>> =C2=A0Subtree assumptions:
>>>>>> =C2=A0(1) Each inode has subtree id. This id is persistently sto=
red inside
>>>>>> =C2=A0 =C2=A0 =C2=A0inode (xattr, usually inside ibody)
>>>>>> =C2=A0(2) Subtree id is inherent from parent directory
>>>>>> =C2=A0(3) Inode can not belongs to different subtree
>>>>>> =C2=A0 =C2=A0 =C2=A0Otherwise changes in one subtree result in c=
hanges in other subtree
>>>>>> =C2=A0 =C2=A0 =C2=A0which contradict to isolation criteria.
>>>>>>
>>>>>> =C2=A0This feature is similar to project-id in XFS. One may assi=
gn some id to
>>>>>> =C2=A0a subtree. Each entry from the subtree may be accounted in=
 directory
>>>>>> =C2=A0subtree quota. Will appear in later patches.
>>>>>>
>>>>>> * Disk layout
>>>>>> =C2=A0Subtree id is stored on disk inside xattr usually inside i=
body.
>>>>>> =C2=A0Xattr is used only as a data storage, It has not user visi=
able xattr
>>>>>> =C2=A0interface.
>>>>>>
>>>>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>>>>
>>>>> Dmitry,
>>>>>
>>>>> I think the idea of subtrees is useful, but I'm curious about oth=
er
>>>>> use cases than just quota.
>>>>>
>>>>> At first glance you are attempting to create a generic subtree
>>>>> functionality for ext4, but criteria 3) above says a inode can on=
ly be
>>>>> in one subtree at a time.
>>>> Theoretically this is possible, but this dramatically complicate t=
hings
>>>> Just think about this. If inode belongs to different subtrees then
>>>> it must have several tree-dquota objects attached to it. This mean=
s
>>>> that quota require great quota redesign.
>>>> Obviously i don't know any use case for this feature. do you know =
any?
>>>
>>> Maybe we're talking about different things. =C2=A0I working with th=
e OHSM
>>> project <http://ohsm.sourceforge.net/>
>>>
>>> We haven't submitted any patches yet, but for one of our features w=
e
>>> have something fairly close to your subtree patch. =C2=A0If we were=
 to
>>> leverage your patch and drop that part of ours we would be in the
>>> unhappy situation that quota and ohsm could not both be enabled on =
the
>>> same filesystem because the ohsm subtree geography is not likely to=
 be
>>> consistent with the quota subtree geography.
>>>
>>> If we call quota and ohsm services then my desire would be to see y=
our
>>> subtree patches support orthoganal subtree groups. =C2=A0One group =
per
>>> service.
>>>
>>> I haven't looked into the actual implementation, but from an API
>>> perspective it is just a matter of adding a service parameter to th=
e
>>> various calls. =C2=A0For a given subtree service group, a given ino=
de could
>>> only be part of one subtree, but a single inode could participate i=
n
>>> multiple subtree service groups.
>> Ok now i think i understand what you are talking about.
>> one subtree <=3D> one service is the main rule i'm standing.
>> If you wan to support several services, no problem
>> I can easily extend xattr to support different services
>> something like this
>> subtree_entry
>> {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 sbe_flags /* entry flags */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 sbe_type =C2=A0/* service type */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 sbe_id =C2=A0 =C2=A0/* subtree id =
*/
>> }
>
> Conceptually agreed.
>
> But you'd still be limited to one subtree_entry per inode with that r=
ight?
>
> Another option would be more like
>
> #define EXT4_SUBTREE_MAX_SERVICE_GROUPS 1
> #define EXT4_SUBTREE_MAX_SERVICE_GROUP_QUOTA 0
>
> // OHSM would patch the above when its ready to submit
>
> subtree_entry[EXT4_SUBTREE_MAX_SERVICE_GROUPS]
> {
>        __le16 sbe_flags /* entry flags */
>        __le32 sbe_id    /* subtree id */
> }
>
> (Clearly that won't actually work as is, but you get the idea.  Each
> service group gets its own flags and id.)
>
> Another option would be separate xattr entries for each subtree group=
=2E
>
> Regardless, it looks very doable and its just a matter of figuring ou=
t
> the best way to support multiple subtree service groups.
Off course i mean that. In fact i'm plan to pack entries in to one
xattr data block because each xattr has significant space overhead.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
