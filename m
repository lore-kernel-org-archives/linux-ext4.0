From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbGliL2V4dDJmczogVXNlIF9fYnVpbHRpbl9wb3A=?=
 =?UTF-8?B?Y291bnQgd2hlbiBhdmFpbGFibGUgU2lnbmVkLW9mZi1ieTogQ3Jpc3RpYW4gUm8=?=
 =?UTF-8?B?ZHLDrWd1ZXogPGNycm9kcmlndWV6QG9wZW5zdXNlLm9yZz4=?=
Date: Sun, 06 Jan 2013 21:53:47 -0300
Message-ID: <50EA1C9B.8040304@opensuse.org>
References: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org> <20130106222020.GA9482@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42436 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3AGAyS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2013 19:54:18 -0500
Received: by mail-ob0-f170.google.com with SMTP id wp18so16795542obc.15
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jan 2013 16:54:18 -0800 (PST)
In-Reply-To: <20130106222020.GA9482@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

El dom 06 ene 2013 19:20:20 CLST, Theodore Ts'o escribi=C3=B3:


> I could imagine a patch which explicitly checks the CPU type using th=
e
> x86 cpuinfo instructure, and only optionally uses the popcount
> instruction if it exists, and uses the optimized code if it doesn't,
> but then again, it's not clear how much it's worth it.

The first incarnation of this patch did exactly that, too ugly didnt=20
not send it. ;)

> Better yet would be if gcc was taught how to recognize the C
> statements in popcount32(), since that's one of the standard,
> intelligent ways of implementing popcount32 (as opposed to the stupid
> way which is apparently used by gcc's runtime library, sigh), and
> inserted code which automatically did the cpuinfo check and fallback
> to popcount if the CPU supports it.  This would be even better since
> then gcc could do a single cpuinfo check, and then automatically use
> the faster SSE[234] instructions as necessary, without having to ask
> application programmers to put in gcc-specific __builtin_* functions

Yeah, I asked GCC developers exactly this, was told to fill a=20
enhancement request.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
