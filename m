From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbGliL2V4dDJmczogVXNlIF9fYnVpbHRpbl9wb3A=?=
 =?UTF-8?B?Y291bnQgd2hlbiBhdmFpbGFibGUgU2lnbmVkLW9mZi1ieTogQ3Jpc3RpYW4gUm8=?=
 =?UTF-8?B?ZHLDrWd1ZXogPGNycm9kcmlndWV6QG9wZW5zdXNlLm9yZz4=?=
Date: Sun, 06 Jan 2013 22:46:34 -0300
Message-ID: <50EA28FA.8040205@opensuse.org>
References: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org> <20130106222020.GA9482@thunk.org> <50EA1C9B.8040304@opensuse.org> <20130107013156.GB12838@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:44507 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3AGBxv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2013 20:53:51 -0500
Received: by mail-ob0-f181.google.com with SMTP id oi10so16403241obb.40
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jan 2013 17:53:51 -0800 (PST)
In-Reply-To: <20130107013156.GB12838@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

El dom 06 ene 2013 22:31:56 CLST, Theodore Ts'o escribi=C3=B3:
> On Sun, Jan 06, 2013 at 09:53:47PM -0300, Cristian Rodr=C3=ADguez wro=
te:
>>
>> Yeah, I asked GCC developers exactly this, was told to fill a
>> enhancement request.
>
> If you could also sned them a bug/enhancement request to use a more
> optimized version of __popcountdi2, that would be great.  I'm not sur=
e
> it helps e2fsprogs much, since it's too hard for us to tell whether w=
e
> are using a version of the gcc runtime that has a optimized or
> unuptomized version of builtin_popcount().
>
> But since it doesn't make that much difference, my preference is to
> just ignore builtin_popcount() for now.  If someone is really using
> 128TB ext4 file systems, and cares about that extra 6 seconds of CPU,
> it's probably going to require the ugly approach of using x86 asm
> statements to determine whether or not we're running on a CPU that
> supports the popcount instruction or not....

with a recent compiler it goes something like this..

unsigned int popcnt(unsigned int w) __attribute__ ((ifunc=20
("resolve_popcnt")));

__attribute__ ((__target__ ("popcnt")))
static unsigned int hw_popcnt(unsigned int w)
{
    return __builtin_popcount(w);
}

static unsigned int soft_popcnt(unsigned int w)
{
    return __builtin_popcount(w);
}

static void (*resolve_popcnt (void)) (void)
{
#if (__GNUC__ > 4) || (__GNUC__ =3D=3D 4 && __GNUC_MINOR__ >=3D 8)
    __builtin_cpu_init();
    if (__builtin_cpu_supports("popcnt"))
        return hw_popcnt;
#else
    unsigned int eax, ebx, ecx, edx;
    if (__get_cpuid (1, &eax, &ebx, &ecx, &edx))
        if (ecx & bit_POPCNT)
            return hw_popcnt;
#endif
    /* If magic does not work, or running old cpu.. */
        return soft_popcnt;
}

then call "popcnt" function in the code, this flies in x86 && ELF &&=20
GCC >=3D 4.6 only though.
The CPU detection code only runs once at load time btw.



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
