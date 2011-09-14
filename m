From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: i_mutex questions
Date: Wed, 14 Sep 2011 09:29:28 +0800
Message-ID: <CAGBYx2b9PjBHOeuQSsU8n5W=A+A7davW0Dw=QMjRdfh6aL7rBQ@mail.gmail.com>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41850 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab1INB32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Sep 2011 21:29:28 -0400
Received: by pzk37 with SMTP id 37so1793544pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 18:29:28 -0700 (PDT)
In-Reply-To: <4E6FA1F9.6080802@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 2:33 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi All,
>
> I have been trying to find a way to synchronize punch hole with read =
and
> write operations with out the use of i_mutex. =A0The concern is that =
after
> punch hole has released the pages inside the hole, another process ma=
y remap
> the page to a block before punch has taken i_data_sem. =A0I think put=
ting
> i_mutex around the punch hole operation would fix this, but since we =
are
> trying to avoid further improper use of i_mutex, I am trying to avoid=
 that
> solution.
>
> I cannot use i_data_sem to protect the pages because it seems most of=
 the
> code has already established a locking order of pages first, then
> i_data_sem. =A0So moving i_data_sem up tends to cause a lot of dead l=
ocks.
> =A0I'm thinking that there probably needs to be a another mutex invol=
ved some
> where, but I wasnt sure if some one is already working on the idea of
> introducing a replacement for i_mutex. =A0So I just wanted to know if=
 there
> are any plans already in motion for this, or if any one else could su=
ggest
> some ideas for the punch hole issue. =A0Thx all!

HI,

Lukas sent out a patch ([PATCH] ext4: Make reads/writes atomic with
i_rwlock semaphore) which collected some feedbacks suggesting using
extent lock instead of a read-write semaphore.  If there is extent
lock implementation in ext4, then fallocate can use it, maybe
dioread-nolock can use it as well, e.g. locking a range and unlocking
the range until the extent is converted from unwritten to init.

Yongqiang.


>
> Allison Henderson
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
