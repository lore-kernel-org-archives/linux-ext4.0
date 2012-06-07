From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Thu, 7 Jun 2012 16:38:31 -0700
Message-ID: <CAGXu5j+mF1jnMXDT-Vpb6T5s34XgTRTeDOdyoXYy_RwNfaUn6w@mail.gmail.com>
References: <471046920.20120604234941@eikelenboom.it>
	<20120605000356.GM29466@outflux.net>
	<1018371644.20120605224154@eikelenboom.it>
	<20120605210806.GB7182@thunk.org>
	<1883708187.20120606090126@eikelenboom.it>
	<CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
	<1482118647.20120606164012@eikelenboom.it>
	<20120607042756.GA30776@thunk.org>
	<20120607222729.GI6938@tux1.beaverton.ibm.com>
	<CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com>
	<20120607225446.GK19839@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
	djwong@us.ibm.com, Sander Eikelenboom <linux@eikelenboom.it>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39754 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2FGXid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2012 19:38:33 -0400
Received: by bkcji2 with SMTP id ji2so1132031bkc.19
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jun 2012 16:38:32 -0700 (PDT)
In-Reply-To: <20120607225446.GK19839@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 7, 2012 at 3:54 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 07, 2012 at 03:40:40PM -0700, Kees Cook wrote:
>>
>> FWIW, I was building the filesystem that triggered this as ext4:
>>
>> =A0 mkfs.ext4 -T default -m 0 -O ^huge_file,^flex_bg -E
>> discard,lazy_itable_init /dev/mapper/...
>
> Ouy of curiosity, was there a reason you chose those particular file
> system parameters? =A0It's a surprising set, because if you're starti=
ng
> with a fresh file system, enabling flex_bg produces a more optimal
> file system layout.

The intent of this was to create a small (64M) initial filesystem as
fast as possible that could be resized (to 3G) on the fly later. (The
performance of the filesystem did not need to be optimized, just the
speed of creation so that the create+mount would happen as fast as
possible, to unblock things waiting for this filesystem to exist.)

In the more common situation, it was built also with:
 -b 4096 ... -E ...,resize=3DMMM ... [device] NNN
where MMM > NNN. And an online resize would be started a bit after it
was created, growing it up to MMM.

-Kees

--=20
Kees Cook
Chrome OS Security
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
