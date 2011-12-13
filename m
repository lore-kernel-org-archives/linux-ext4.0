From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/2] ext4: avoid hangs in ext4_da_should_update_i_disksize()
Date: Tue, 13 Dec 2011 09:05:46 +0800
Message-ID: <CAGBYx2bSDr79rrns4FNZ=6TRa8ahKpHr6njuLqh8YYKzwH+HOQ@mail.gmail.com>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
	<1323656828-24465-2-git-send-email-aarcange@redhat.com>
	<CAGBYx2Y3WUc1m0BvTyrDcEyh0TTeLriWGA3YjgKcGoW=s8PYnw@mail.gmail.com>
	<20111212165758.GF16411@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53296 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1LMBFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2011 20:05:47 -0500
Received: by ggdk6 with SMTP id k6so1819909ggd.19
        for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 17:05:46 -0800 (PST)
In-Reply-To: <20111212165758.GF16411@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 13, 2011 at 12:57 AM, Andrea Arcangeli <aarcange@redhat.com=
> wrote:
> On Mon, Dec 12, 2011 at 11:28:21AM +0800, Yongqiang Yang wrote:
>> Hi Andrea,
>>
>> I can not figure out why ext4 hangs. =A0Could you explain more on ha=
nging?
>
> Well I tried to explain it in the changeset comment.
>
> If "copied" is zero, end/offset/idx becomes -1, and this loops:
>
> =A0 =A0 =A0 =A0for (i =3D 0; i < idx; i++)
>
> definitely a bug and checking ext4 git I don't see anything fixing it=
=2E
Got it.  Thanks.

Looks good to me.


--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
