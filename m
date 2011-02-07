From: Matt <jackdachef@gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 7 Feb 2011 18:56:28 +0000
Message-ID: <AANLkTinybnXVk9WRsvrLLfhWGXm1=jQnTGvE0JT6=RXs@mail.gmail.com>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
	<20110207174552.GC3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50660 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1BGS4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 13:56:30 -0500
In-Reply-To: <20110207174552.GC3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 7, 2011 at 5:45 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>
>> So that means that the file-corruption which existed until 2.6.37-rc=
6
>> and got triggered (for me) more easily via "dm crypt: scale to
>> multiple CPUs"
>> is fixed now ?
>
> Well, a patch exists for it that will be merged into 2.6.38.
>
>> That should give ext4 a nice speedup for >=3D2.6.38 :)
>
> I'm not going to make it be the default for 2.6.38, since it's fairly
> late in the -rc features. =A0People who want it can explicitly enable=
 it
> using the mount option mblk_io_submit, though. =A0(And let me know yo=
ur
> success stories! =A0:-) I will be enabling it as the default in
> 2.6.39-rc1.
>

Hi Ted,

I guess it should be save to enable it with 2.6.37, dm-crypt multi-cpu
patch and the following patch ?

"ext4: Fix data corruption with multi-block writepages support"
(of course that's the minimum - it would be better to pull in the ext4
changes for 2.6.38)


=46or a short time I had it activated (via additional) mblk_io_submit
mount-command on my portage-partition (where the portage-ball of my
Gentoo system is).
I was curious to see what messages I would get and wondered why there
was nothing about mballoc mentioned

If I recall correctly there were always messages in the past, like:

EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled

these are from 2.6.28 -

I'm only getting:

EXT4-fs (dm-3): mounted filesystem with ordered data mode.

or

EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts:
commit=3D60,barrier=3D1

(I like to set the barriers / flushes explicitly).

Sorry if I didn't follow development but these messages were kind of
more and more silenced ?


Thanks !


>> Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >
>
> Sure!

Thanks !


>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

Regards

Matt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
