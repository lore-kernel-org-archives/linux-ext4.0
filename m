From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] jbd: Make jbd transactions come from its own cache.
Date: Mon, 13 Jun 2011 17:02:51 -0700
Message-ID: <BANLkTimhnzadsUOYCJ2J--GfJL74svFPnw@mail.gmail.com>
References: <1307784961-1485-1-git-send-email-mkatiyar@gmail.com> <20110613164121.d2ca952e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48991 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab1FNADM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jun 2011 20:03:12 -0400
Received: by qwk3 with SMTP id 3so2416572qwk.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jun 2011 17:03:11 -0700 (PDT)
In-Reply-To: <20110613164121.d2ca952e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 13, 2011 at 4:41 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 11 Jun 2011 02:36:01 -0700
> Manish Katiyar <mkatiyar@gmail.com> wrote:
>
>> Allocate a slab cache for jbd transaction allocations. It may help t=
o test
>> various memory failure scenarios.
>
> This doesn't seem terribly useful to me. =A0That's truly ancient code=
 and
> the change rate is really low. =A0If there were problem in there then
> we'd already know about them. =A0And the allocation frequency for the=
se
> objects is very low.
>
> If you had some deeper reason for making this change, please describe
> it. =A0For example, were you chasing some bug?

Hi Andrew,

   I was doing similar changes for jbd2, hence did it for jbd too. The
changes for jbd2 were done so that we can use the
fault injection framework to introduce/test ENOMEM situations from the
journal transaction allocation layer and test
how well the callers (ext4 code in particular) deal with such
situations and fix them if required.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
