From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Tue, 9 Feb 2010 09:52:37 -0500
Message-ID: <87f94c371002090652w34f91a75m2d832465b113ec98@mail.gmail.com>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
	 <87f94c371002081554k3e4d6019q332602fea344ccc9@mail.gmail.com>
	 <874olqpvtt.fsf@openvz.org>
	 <87f94c371002090536v2450e67dlb77fa70bfc46cec0@mail.gmail.com>
	 <87sk9awm66.fsf@openvz.org>
	 <87f94c371002090629l6e496b23w8eeb7bbdf3e9b1fe@mail.gmail.com>
	 <87ljf2wjmd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f183.google.com ([209.85.223.183]:42835 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab0BIOwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 09:52:37 -0500
Received: by iwn13 with SMTP id 13so8058229iwn.25
        for <linux-ext4@vger.kernel.org>; Tue, 09 Feb 2010 06:52:37 -0800 (PST)
In-Reply-To: <87ljf2wjmd.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 9, 2010 at 9:48 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
> Greg Freemyer <greg.freemyer@gmail.com> writes:
>
>> On Tue, Feb 9, 2010 at 8:53 AM, Dmitry Monakhov <dmonakhov@openvz.or=
g> wrote:
>>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>>
>>>> On Tue, Feb 9, 2010 at 5:06 AM, Dmitry Monakhov <dmonakhov@openvz.=
org> wrote:
>>>>> Greg Freemyer <greg.freemyer@gmail.com> writes:
>>>>>
>>>>>> On Mon, Feb 8, 2010 at 8:28 AM, Dmitry Monakhov <dmonakhov@openv=
z.org> wrote:
>>>>>>> * Abstract
>>>>>>> =A0A subtree of a directory tree T is a tree consisting of a di=
rectory
>>>>>>> =A0(the subtree root) in T and all of its descendants in T.
>>>>>>>
>>>>>>> =A0Subtree feature allows to create an isolated (from user poin=
t of view)
>>>>>>> =A0trees.
>>>>>>>
>>>>>>> =A0Subtree assumptions:
>>>>>>> =A0(1) Each inode has subtree id. This id is persistently store=
d inside
>>>>>>> =A0 =A0 =A0inode (xattr, usually inside ibody)
>>>>>>> =A0(2) Subtree id is inherent from parent directory
>>>>>>> =A0(3) Inode can not belongs to different subtree
>>>>>>> =A0 =A0 =A0Otherwise changes in one subtree result in changes i=
n other subtree
>>>>>>> =A0 =A0 =A0which contradict to isolation criteria.
>>>>>>>
>>>>>>> =A0This feature is similar to project-id in XFS. One may assign=
 some id to
>>>>>>> =A0a subtree. Each entry from the subtree may be accounted in d=
irectory
>>>>>>> =A0subtree quota. Will appear in later patches.
>>>>>>>
>>>>>>> * Disk layout
>>>>>>> =A0Subtree id is stored on disk inside xattr usually inside ibo=
dy.
>>>>>>> =A0Xattr is used only as a data storage, It has not user visiab=
le xattr
>>>>>>> =A0interface.
>>>>>>>
>>>>>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>>>>>
>>>>>> Dmitry,
>>>>>>
>>>>>> I think the idea of subtrees is useful, but I'm curious about ot=
her
>>>>>> use cases than just quota.
>>>>>>
>>>>>> At first glance you are attempting to create a generic subtree
>>>>>> functionality for ext4, but criteria 3) above says a inode can o=
nly be
>>>>>> in one subtree at a time.
>>>>> Theoretically this is possible, but this dramatically complicate =
things
>>>>> Just think about this. If inode belongs to different subtrees the=
n
>>>>> it must have several tree-dquota objects attached to it. This mea=
ns
>>>>> that quota require great quota redesign.
>>>>> Obviously i don't know any use case for this feature. do you know=
 any?
>>>>
>>>> Maybe we're talking about different things. =A0I working with the =
OHSM
>>>> project <http://ohsm.sourceforge.net/>
>>>>
>>>> We haven't submitted any patches yet, but for one of our features =
we
>>>> have something fairly close to your subtree patch. =A0If we were t=
o
>>>> leverage your patch and drop that part of ours we would be in the
>>>> unhappy situation that quota and ohsm could not both be enabled on=
 the
>>>> same filesystem because the ohsm subtree geography is not likely t=
o be
>>>> consistent with the quota subtree geography.
>>>>
>>>> If we call quota and ohsm services then my desire would be to see =
your
>>>> subtree patches support orthoganal subtree groups. =A0One group pe=
r
>>>> service.
>>>>
>>>> I haven't looked into the actual implementation, but from an API
>>>> perspective it is just a matter of adding a service parameter to t=
he
>>>> various calls. =A0For a given subtree service group, a given inode=
 could
>>>> only be part of one subtree, but a single inode could participate =
in
>>>> multiple subtree service groups.
>>> Ok now i think i understand what you are talking about.
>>> one subtree <=3D> one service is the main rule i'm standing.
>>> If you wan to support several services, no problem
>>> I can easily extend xattr to support different services
>>> something like this
>>> subtree_entry
>>> {
>>> =A0 =A0 =A0 =A0__le16 sbe_flags /* entry flags */
>>> =A0 =A0 =A0 =A0__le16 sbe_type =A0/* service type */
>>> =A0 =A0 =A0 =A0__le32 sbe_id =A0 =A0/* subtree id */
>>> }
>>
>> Conceptually agreed.
>>
>> But you'd still be limited to one subtree_entry per inode with that =
right?
>>
>> Another option would be more like
>>
>> #define EXT4_SUBTREE_MAX_SERVICE_GROUPS 1
>> #define EXT4_SUBTREE_MAX_SERVICE_GROUP_QUOTA 0
>>
>> // OHSM would patch the above when its ready to submit
>>
>> subtree_entry[EXT4_SUBTREE_MAX_SERVICE_GROUPS]
>> {
>> =A0 =A0 =A0 =A0__le16 sbe_flags /* entry flags */
>> =A0 =A0 =A0 =A0__le32 sbe_id =A0 =A0/* subtree id */
>> }
>>
>> (Clearly that won't actually work as is, but you get the idea. =A0Ea=
ch
>> service group gets its own flags and id.)
>>
>> Another option would be separate xattr entries for each subtree grou=
p.
>>
>> Regardless, it looks very doable and its just a matter of figuring o=
ut
>> the best way to support multiple subtree service groups.
> Off course i mean that. In fact i'm plan to pack entries in to one
> xattr data block because each xattr has significant space overhead.
>

Sounds great.  Does xfs support multiple service groups with its
current offering?

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
