From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp limits
Date: Sat, 8 Apr 2017 19:58:39 -0700
Message-ID: <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com> <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        y2038 Mailman List <y2038@lists.linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35523 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdDIC6k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Apr 2017 22:58:40 -0400
In-Reply-To: <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> Allow read only mounts for filesystems that do not
>> have maximum timestamps beyond the y2038 expiry
>> timestamp.
>
> This option seems arbitrary and pointless.
>
> Nobody sane should ever enable it except for testing, but for testing
> it would be much better to simply specify what the limit should be:
> 2038 is not magical for all filesystems, because the base may be
> different.

Yes, the way the patch is right now, it is meant only for testing
y2038 readiness.
The feature is meant for system wide tests and not individual filesystem tests.

The original idea was to disallow writes on all filesystem mounts that
were not able to update times at the time of mount, meaning max time
supported by the filesystem should be greater than current system
time. But, then we end up with the problem of what to do about mounts
whose max time exceeds current time after mount. This can be handled
by some logic while updating inode times. But, maybe this level of
complexity is not required and we could just stick to the former use
case. And, just print a warning in the latter case. This is what
pushes the feature to be something more than y2038 readiness.

> And honestly, for testing, it would be much better to just make it a
> mount option rather than some crazy system-wide one.

The patch allows the y2038 number to be changed at compile time. I can
extend the sysctl and boot option to allow changing of this limit also
if that is preferred.

We also proposed the mount option route in the RFC. But, we received
no preferences/ comments. We proceeded with the sysctl option because
this allows us to extend this feature into disallowing writes on non
updatable time filesystems.

I could change this to providing a mount option instead if you think
that is better.

-Deepa
