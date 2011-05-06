From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Ext4 punch hole 3/5 v6] Ext4 Punch Hole Support: Punch out extents
Date: Fri, 6 May 2011 09:57:00 +0800
Message-ID: <BANLkTimZ10gzsYmEFK0q3=8gLNFjHwYs7w@mail.gmail.com>
References: <4DC031BE.8070807@linux.vnet.ibm.com>
	<BANLkTi=yXiv0emuC7h9eUGs1AiJNv1aWNw@mail.gmail.com>
	<4DC34AC1.8090505@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65180 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1EFB5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 May 2011 21:57:01 -0400
Received: by vxi39 with SMTP id 39so2918287vxi.19
        for <linux-ext4@vger.kernel.org>; Thu, 05 May 2011 18:57:00 -0700 (PDT)
In-Reply-To: <4DC34AC1.8090505@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> Hi there,
>>
>> Sorry for so late voice.
>>
>> ext4_ext_remove_space() are supposed to be used by truncate, so it
>> remove blocks from EOF to start as indicated by while-loop. =A0 Now =
it
>> has an end, so I think we'd better limit the while loop from the end
>> to the start, but not from EOF to the start.
>>
>> we can achieve this by assigning path right before while-loop.
>
> Hi there,
>
> Well, I tried setting the path using find_extent, but it doesnt look =
like it
> quite worked out. Could you expand a little more on this? =A0It is no=
t
> immediately clear to me how we can do this by setting path. =A0It loo=
ks like
> path is an array of paths that keep track of where we are in the tree=
=2E =A0The
> current sequence of paths represent the current location, but I dont =
know
> how we could set up a particular sequence of paths with out walking i=
nto the
> tree to know what it is. =A0I think the while loop just detects when =
the
> search has come back around to top of the tree. If I understand the c=
ode
> correctly, we would need a sequence of the paths starting at the =A0d=
eepest
> path that can still descend to all the extents in the hole, and the s=
equence
> would need to end at the path that points to the extent that contains=
 the
> end of the hole. Thus limiting the search to only that subtree that s=
pans
> the hole. =A0At least that is my interpretation of the code. =A0It th=
at correct,
> or maybe there is something I missed?
Correct.
>
> If that is how it works, maybe what we could do instead check
> (path[i].p_idx->ei_block < end) when deciding weather or not to desce=
nd? =A0I
> think that would get rid of needlessly walking space that is beyond t=
he end
> of the hole. =A0And then when we return from the ext4_ext_rm_leaf, we=
 can
> check to see if the leaf contains extents appearing before the hole, =
and
> then quit out if it does. =A0Does that sound correct? =A0Thx!
Yes, it's applicable and easier.

find_extent doe not work, because path.p_block is used to another
thing, it is different from find_extent.

Setting path just can control end, start can not be controlled this way=
=2E

Yongqiang.

>
> Allison Henderson
>
>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* root level has p_=
bh =3D=3D NULL, brelse() eats this
>>> */
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(path[i].p_bh)=
;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path[i].p_bh =3D NUL=
L;
>>> @@ -3443,7 +3565,7 @@ void ext4_ext_truncate(struct inode *inode)
>>>
>>> =A0 =A0 =A0 =A0last_block =3D (inode->i_size + sb->s_blocksize - 1)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0>> =A0EXT4_BLOCK_SIZ=
E_BITS(sb);
>>> - =A0 =A0 =A0 err =3D ext4_ext_remove_space(inode, last_block);
>>> + =A0 =A0 =A0 err =3D ext4_ext_remove_space(inode, last_block, EXT_=
MAX_BLOCK);
>>>
>>> =A0 =A0 =A0 =A0/* In a multi-transaction truncate, we only make the=
 final
>>> =A0 =A0 =A0 =A0 * transaction synchronous.
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
