From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL]
Date: Fri, 11 Feb 2011 16:33:59 -0800
Message-ID: <AANLkTineDxntR0ZTXdgXrc6qx6pATTORgOwFR5+w5MLN@mail.gmail.com>
References: <20110211134058.GA4309@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab1BLAeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Feb 2011 19:34:21 -0500
In-Reply-To: <20110211134058.GA4309@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 11, 2011 at 5:40 AM, Ted Ts'o <tytso@mit.edu> wrote:
>
> Please pull from:
>
> =A0git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_l=
inus
>
> to get regression and bug fixes for 2.6.38.
>
> Eric Sandeen (3):
> =A0 =A0 =A0ext4: serialize unaligned asynchronous DIO

This is a completely disgusting patch, and it causes warnings like this=
:

 fs/ext4/file.c: In function =91ext4_aiodio_wait=92:
 fs/ext4/file.c:60:44: warning: cast from pointer to integer of differe=
nt size

because that disgusting patch does things like

  #define ext4_aio_mutex(v)  (&ext4__aio_mutex[((unsigned)v) % EXT4_WQ_=
HASH_SZ])

which is just terminally broken.

It's terminally broken for multiple reasons, too. It's not just "oh, a
warning". It's a case of "oh, THAT CODE IS UTTER CRAP". The warning
was just the lucky reason I noticed the totally unacceptable code.

Dammit, don't send sh*t to me this late in the release cycle. This
clearly went through _zero_ quality control.

                   Linus

PS. If people don't understand why that code is utter crap, let me
give you a hint: macro argument expansion vs operator precedence.

PPS. And btw, the warning is unacceptable too. Cast the thing to
"unsigned long" (or uintptr_t, but quite frankly, in the kernel I'd
suggest "unsigned long" rather than the more obscure standard types)
after you've fixed the macro argument problem.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
