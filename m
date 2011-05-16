From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: fix NULL pointer dereference in ext4_quota_off
Date: Mon, 16 May 2011 17:40:40 +0300
Message-ID: <BANLkTi=Je5K9vRiiRVF39rZ+xe32QAgRWw@mail.gmail.com>
References: <BANLkTin4vEQZ4W5LQT36U3BVxWG4VeDZYw@mail.gmail.com>
	<20110516101154.GB5344@quack.suse.cz>
	<20110516140435.GA4953@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56120 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab1EPOkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 10:40:41 -0400
Received: by ewy4 with SMTP id 4so1265461ewy.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 07:40:40 -0700 (PDT)
In-Reply-To: <20110516140435.GA4953@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 5:04 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, May 16, 2011 at 12:11:54PM +0200, Jan Kara wrote:
>> =A0 Ah, I see we worked on the patch together :). Anyway, Ted can pi=
ck any of
>> them I guess.
>
> I actually combined the commit description and used elements from bot=
h
> of them. =A0Jan's short description was a better summary, but I liked
> Amir description of the commit (note though that if you're going to
> use abberviated git commit id's, please don't shorten them to 10-12
> characters since given the size of the git repository, shorter git
> commit id's could suffer from hash collision).

Note taken.
I suppose this is not going into 2.6.39(?), so CC: stable is in order.
Thanks,
Amir.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> ext4: fix oops in ext4_quota_off()
>
> From: Amir Goldstein <amir73il@gmail.com>
>
> If quota is not enabled when ext4_quota_off() is called, we must not
> dereference quota file inode since it is NULL. =A0Check properly for
> this.
>
> This fixes a bug in commit 21f976975cbe (ext4: remove unnecessary
> [cm]time update of quota file), which was merged for 2.6.39-rc3.
>
> Reported-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
