From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Thu, 26 May 2011 21:11:14 -0700
Message-ID: <BANLkTikvZSPmO8bFsSh8QhSKK=OdPyGFUg@mail.gmail.com>
References: <4DDCAF18.8030809@gmail.com> <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com> <20110525081333.GB4427@quack.suse.cz>
 <20110526022251.GG9520@thunk.org> <E4B2E5DC-AC13-4AB9-870E-6F3584991396@dilger.ca>
 <20110526140558.GJ9520@thunk.org> <20110526144956.GB5123@quack.suse.cz> <20110526150846.GL9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65242 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1E0ELf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 May 2011 00:11:35 -0400
Received: by qyg14 with SMTP id 14so770082qyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 May 2011 21:11:34 -0700 (PDT)
In-Reply-To: <20110526150846.GL9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2011 at 8:08 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, May 26, 2011 at 04:49:56PM +0200, Jan Kara wrote:
>> =A0 No need to do this. If you make JBD2 use a separate slab for tra=
nsaction
>> structures (trivial and makes some sense anyway), you can use
>> fault-injection framework to do exactly what you describe above (see
>> Documentation/fault-injection/fault-injection.txt and look for fails=
lab).
>
> Thanks for pointing me at the fault-injection framework; it's not
> something I've used before. =A0I'll have to take a look at it.
>
>> =A0 But if we just fail all transaction allocations with say 10% pro=
bability,
>> it should work as well, shouldn't it? We'd just retry those allocati=
ons
>> whose failure we cannot handle and eventually succeed. Or do I miss
>> something?
>
> The reason why I only wanted to fail the transactions relating to the
> writeback path is because other failures will get reflected back to
> userspace, and would thus change the behavior of the stress test. =A0=
(If
> we used fsstress, it would cause fsstress to immediately stop and
> fail, for example.)
>
> That is the one thing that worries me a little about this patch serie=
s
> in general. =A0If we suddenly start failing open() or rename() or
> chmod() syscalls with ENOMEM in low memory situations, what of
> programs that aren't doing adequate error checking? =A0Sure, other fi=
le
> systems will do this, but the bulk of the users use ext3/ext4, and
> remember how much kvetching and complaining when xfs was the first
> file system to require user space applications to actually use fsync(=
)
> if they wanted their files to be safe after a power failure.
>
> I worry that there are a lot of incompetently written editors out
> there that aren't doing error checking, or worse yet, package manager=
s
> or other security-critical programs that aren't doing error checking,
> and which won't notice when an syscall fails in a low-memory
> situation, leading to either (a) user data loss (which the applicatio=
n
> programers will lay at the feet of the file system developers, don't
> doubt it), or (b) security holes.
>
> I'm not sure there's a way to address this concern, and I'm going not
> NACK'ing this patch series on that basis --- but I do worry that it
> might not improve the situation by a whole lot, and may in fact cause
> some problems, at the end of the day.

If there are applications which don't expect this behaviour or can't ha=
ndle such
cases, we can always add a sysfs flag to turn of this behavior complete=
ly and
always retry like old behavior. This may be ugly, but would help till
ppl start realising
this behavior and writing applications appropriately.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
