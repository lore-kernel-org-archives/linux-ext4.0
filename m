From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32972] EXT4 causes corrupt BitTorrent downloads
Date: Mon, 11 Apr 2011 01:50:39 GMT
Message-ID: <201104110150.p3B1odwO003558@demeter1.kernel.org>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53303 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1DKBuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 21:50:40 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3B1od7M003559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 01:50:39 GMT
In-Reply-To: <bug-32972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D32972





--- Comment #4 from Yongqiang Yang <xiaoqiangnk@gmail.com>  2011-04-11 =
01:50:38 ---
On Mon, Apr 11, 2011 at 9:46 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Apr 10, 2011 at 10:30:13PM +0800, Yongqiang Yang wrote:
>> So the right code should be=EF=BC=9A
>>
>> =C2=A0 =C2=A0 =C2=A0 bh->b_state =3D (bh->b_state & ~EXT4_MAP_FLAGS)=
 | map.m_flags;
>> =C2=A0 =C2=A0 =C2=A0 map_bh(bh, inode->i_sb, map.m_pblk);
>> =C2=A0 =C2=A0 =C2=A0 if (buffer_unwritten(bh)) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* A delayed write =
to unwritten bh should be marked
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* new and map=
ped. =C2=A0Mapped ensures that we don't do
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* get_block m=
ultiple times when we write to the same
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* offset and =
new ensures that we do proper zero out
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* for partial=
 write.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_buffer_new(bh);
>> =C2=A0 =C2=A0 =C2=A0 }
>
> Actually, I'm much more comfortable backing out commit 6de9843da
> entirely. =C2=A0The above is *not* equivalent to what we had before -=
--
> consider the case where ext4_map_blocks returns !EXT4_MAP_MAPPED &&
> !EXT4_MAP_UNWRITTEN.
>
> I don't *think* this should happen in the case where ext4_map_blocks
> returns a value > 0, but the fact that it's not obvious, means I'd
> much rather keep things the way that they are. =C2=A0It's not like dr=
opping
> the set_buffer_mapped(bh) was saving anything measurable anyway....
Agree.  this way, the comment for unwritten case is also much clearer.

Yongqiang
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
