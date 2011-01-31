From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation if
 caller can handler failures
Date: Sun, 30 Jan 2011 17:04:09 -0800
Message-ID: <AANLkTin8_mKJB9JuBzXAyZ9-22B+a2Sdbg0b5VbJFdWY@mail.gmail.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com>
 <20110125161745.GC4088@quack.suse.cz> <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
 <20110130194251.GE4258@thunk.org> <AANLkTik8_iO=LF=HqmZyNGC=t5TVqEHzb=G78M-NWMHR@mail.gmail.com>
 <20110130200712.GF4258@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57056 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1AaBEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 20:04:30 -0500
Received: by qwa26 with SMTP id 26so4962244qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 17:04:30 -0800 (PST)
In-Reply-To: <20110130200712.GF4258@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 30, 2011 at 12:07 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Jan 30, 2011 at 11:44:25AM -0800, Manish Katiyar wrote:
>>
>> Do you mean separate patch for each of the changed functions ?
>
> Unless the cleanups for a set of functions are all the same issue,
> yes. =A0The idea is that commit description should apply to all of th=
e
> patch hunks in the commit.
>
> That way if there is a problem, it becomes easier to bisect and then
> determine what's going on by reading the commit description. =A0It al=
so
> becomes easier to review the changes, as well.
>
> Does that make sense?

Hi Ted,

Resending the above patch broken in following series of patch.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
