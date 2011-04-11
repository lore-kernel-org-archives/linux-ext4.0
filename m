From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Bug 32972] New: EXT4 causes corrupt BitTorrent downloads
Date: Mon, 11 Apr 2011 09:50:06 +0800
Message-ID: <BANLkTim3Bg08cC9Cn+JWj-73Z5_AAUF6xg@mail.gmail.com>
References: <bug-32972-13602@https.bugzilla.kernel.org/>
	<BANLkTikQa3UaBVVFdrvzwUcdR_qvOPcmFw@mail.gmail.com>
	<20110411014625.GA5802@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bugzilla-daemon@bugzilla.kernel.org, damien@grassart.com,
	feng.tang@intel.com, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:36213 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1DKBuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Apr 2011 21:50:07 -0400
Received: by pxi2 with SMTP id 2so2733158pxi.10
        for <linux-ext4@vger.kernel.org>; Sun, 10 Apr 2011 18:50:06 -0700 (PDT)
In-Reply-To: <20110411014625.GA5802@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
