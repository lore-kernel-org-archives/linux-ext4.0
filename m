From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Fri, 21 Aug 2009 08:46:37 +0200
Message-ID: <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
References: <20090820015624.GE524@hash.localnet>
	 <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
	 <20090820111937.GF524@hash.localnet>
	 <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
	 <20090821020633.GA25571@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Paris <eparis@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Bob Copeland <me@bobcopeland.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:36502 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZHUGqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 02:46:37 -0400
In-Reply-To: <20090821020633.GA25571@hash.localnet>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/8/21 Bob Copeland <me@bobcopeland.com>:
> On Thu, Aug 20, 2009 at 02:02:49PM +0200, Vegard Nossum wrote:
>> > I'll try that and kmemcheck next.
>>
>> Hm, I'm afraid kmemcheck gives some known false positives related to
>> bitfields in ext4 code, so in the case that something turned up, it
>> might be hard to distinguish it from those false positives.
>
> Well I didn't get anything from ext4 so far. =C2=A0I did hit one with
> fsnotify:
>
> WARNING: kmemcheck: Caught 32-bit read from freed memory (f34a443c)
> eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee008a06f700011000
> =C2=A0a a a a a a a a a a a a a a a a a a a a a a a a f f f f f f f f
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>
> Pid: 2745, comm: fsck.ext4 Not tainted (2.6.31-rc6 #2) MacBook1,1
> EIP: 0060:[<c10f3656>] EFLAGS: 00010217 CPU: 0
> EIP is at inotify_handle_event+0x76/0xc0
> EAX: f34a443c EBX: f34a4438 ECX: 00000000 EDX: f6732000
> ESI: f6559764 EDI: 00000000 EBP: f6733f0c ESP: c1527450
> =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> CR0: 8005003b CR2: f6c046d4 CR3: 367fb000 CR4: 000026d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
> =C2=A0[<c10f0d78>] fsnotify+0xa8/0x130
> =C2=A0[<c10c5e11>] __fput+0xb1/0x1e0
> =C2=A0[<c10c5f55>] fput+0x15/0x20
> =C2=A0[<c10c2ca7>] filp_close+0x47/0x80
> =C2=A0[<c10c2d54>] sys_close+0x74/0xc0
> =C2=A0[<c1002ec8>] sysenter_do_call+0x12/0x36
> =C2=A0[<ffffffff>] 0xffffffff
>
> I think that is list_empty() here where %eax is list_head
> and event_list->next is the read location... which definitely
> doesn't look like a pointer, if I'm reading it correctly.

I think f34a443c is a valid pointer. On my machine, at least:

[    0.004000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)

>
> inotify_fsnotify.o:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* did event_priv get attached? */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (list_empty(&fsn_event_priv->event_list=
))
> =C2=A0143: =C2=A0 8d 43 04 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0lea =C2=A0 =C2=A00x4(%ebx),%eax
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0event_priv =3D kmem_cache_alloc(event_priv=
_cachep, GFP_KERNEL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!event_priv))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM=
;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fsn_event_priv =3D &event_priv->fsnotify_e=
vent_priv_data;
> =C2=A0146: =C2=A0 39 43 04 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0cmp =C2=A0 =C2=A0%eax,0x4(%ebx) =C2=A0 =C2=A0 <=3D=3D=3D r=
ead here
> =C2=A0149: =C2=A0 74 1d =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 je =C2=A0 =C2=A0 168 <inotify_handle_event+0x98>

I can see somewhat of a race, I think:

1. userspace calls inotify_read(), where we wait for something to happe=
n:

249         while (1) {
250                 prepare_to_wait(&group->notification_waitq, &wait,
TASK_INTERRUPTIBLE);
251
252                 mutex_lock(&group->notification_mutex);
253                 kevent =3D get_one_event(group, count);
254                 mutex_unlock(&group->notification_mutex);

2. an event occurs, and inotify_handle_event() calls
fsnotify_add_notify_event():

 64         ret =3D fsnotify_add_notify_event(group, event, fsn_event_p=
riv);
 65         /* EEXIST is not an error */
 66         if (ret =3D=3D -EEXIST)
 67                 ret =3D 0;

3. fsnotify_add_notify_event() adds the fsn_event_priv to the event,
and adds the event to the group, and finally wakes up anybody who is
waiting on &group->notification_waitq:

230         fsnotify_get_event(event);
231         list_add_tail(&holder->event_list, list);
232         if (priv)
233                 list_add_tail(&priv->event_list, &event->private_da=
ta_list);
234         spin_unlock(&event->lock);
235         mutex_unlock(&group->notification_mutex);
236
237         wake_up(&group->notification_waitq);

4. inotify_read() wakes up and frees the event:

253                 kevent =3D get_one_event(group, count);

5. inotify_handle_event() now dereferences the event_priv pointer,
which was already freed:

 69         /* did event_priv get attached? */
 70         if (list_empty(&fsn_event_priv->event_list))


I think that's it. Any thoughts? I put Eric Paris on Cc.


Vegard
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
