From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp limits
Date: Tue, 25 Apr 2017 21:47:45 +0200
Message-ID: <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com> <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32833 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1169344AbdDYTrq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Apr 2017 15:47:46 -0400
In-Reply-To: <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 9, 2017 at 4:58 AM, Deepa Dinamani <deepa.kernel@gmail.com> wrote:
>>> Allow read only mounts for filesystems that do not
>>> have maximum timestamps beyond the y2038 expiry
>>> timestamp.
>>
>> This option seems arbitrary and pointless.
>>
>> Nobody sane should ever enable it except for testing, but for testing
>> it would be much better to simply specify what the limit should be:
>> 2038 is not magical for all filesystems, because the base may be
>> different.
>
> Yes, the way the patch is right now, it is meant only for testing
> y2038 readiness.
> The feature is meant for system wide tests and not individual filesystem tests.

There is one global option that I want to see, and that is for completely
disabling all components that are known to be broken in y2038.

We could do this with just a compile-time option that primarily
turns off all drivers using the 32-bit time_t, but the same compile-time
option can also force the file system to be read-only.

I don't see this just as something we want to do for testing, but
also as a safeguard for people shipping embedded systems with
long service life: If something can go wrong after write-mounting
an ext3 file system after 2038, it's better to force a behavior now
that can be reasonably expected not to change.

Between doing a compile-time option or a boot-time option, doing
it purely compile-time is probably better as it gives us the possible
additional checking when we hide the time_t definition.

We can do the boot-time option as well, to set a particular limit
other than the one enforced at compile time. Passing a year
number like "fstimestampcheck=2099" would address Linus'
concern about the cutoff being arbitrary.

I would also make the default limit higher than 2038, as at
least the Apple HFS/HFS+ file systems break only a bit later
in 2040. However, I don't think any other file system breaks
until 2099 (some Microsoft file systems), which would be
the next reasonably default cutoff IMO.

>> And honestly, for testing, it would be much better to just make it a
>> mount option rather than some crazy system-wide one.
>
> The patch allows the y2038 number to be changed at compile time. I can
> extend the sysctl and boot option to allow changing of this limit also
> if that is preferred.
>
> We also proposed the mount option route in the RFC. But, we received
> no preferences/ comments. We proceeded with the sysctl option because
> this allows us to extend this feature into disallowing writes on non
> updatable time filesystems.
>
> I could change this to providing a mount option instead if you think
> that is better.

I don't see much value in a mount option that prevents the use,
but maybe a mount option to override the global setting to make
an exception for someone who does want to mount a particular
(known-broken) file system despite having the stricter global setting.

         Arnd
