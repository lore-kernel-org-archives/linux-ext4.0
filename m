From: Peng tao <bergwolf@gmail.com>
Subject: Re: [PATCH-e2fsprogs] Allow clearing flex_bg if only one group per
	flex
Date: Tue, 3 Mar 2009 11:02:02 +0800
Message-ID: <6149e97b0903021902r228e4de2ia95dd4f39ef8f06a@mail.gmail.com>
References: <1235982524-7673-1-git-send-email-bergwolf@gmail.com>
	 <20090302123908.GJ6973@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:56205 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZCCDCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 22:02:08 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2570033rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2009 19:02:03 -0800 (PST)
In-Reply-To: <20090302123908.GJ6973@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 2, 2009 at 8:39 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Mar 02, 2009 at 04:28:44PM +0800, Peng Tao wrote:
>> This can be caused by tune2fs -O flex_bg. And clearing flex_bg on su=
ch
>> partitions is harmless.
>
> It's actually not necessarily harmless; e2fsck could have already
> assigned new bitmap and inode tables outside of the block group. =C2=A0=
If
> you want to enable this, you need to actually check to make sure all
> of the block/inode bitmap blocks and inode tables are within their ow=
n
> block group before allowing flex_bg to be cleared.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>
Hi, Ted

=46urther looking into the code, I realized that tune2fs -O^flex_bg is
already supported if it doesn't break file system consistency. So
please ignore this patch.
I will send you a new patch for enabling tune2fs -I dealing with the
similar scenario.

Cheers,
Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
