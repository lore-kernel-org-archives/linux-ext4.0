From: Ruoxin Jiang <rj2394@columbia.edu>
Subject: Re: Ext4 Bug Report
Date: Thu, 7 Sep 2017 19:31:09 -0400
Message-ID: <CAFzqJcZYTi7-V1nd-yhnvrdCkdqp1tGAN4wmUODEXQc5Fi73Fw@mail.gmail.com>
References: <CAFzqJcYcZHFzSJEGKrjHy3HgwDfiDHg5_wbj6GM7g+4sFPZkDQ@mail.gmail.com>
 <20170906192815.orfe2pr6vkakix6u@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org, Suman Jana <sumanj@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:54121 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750966AbdIGXbM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Sep 2017 19:31:12 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v87NRQq1040436
        for <linux-ext4@vger.kernel.org>; Thu, 7 Sep 2017 19:31:12 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id EB4126D
        for <linux-ext4@vger.kernel.org>; Thu,  7 Sep 2017 19:31:11 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu [128.59.72.14])
        by hazelnut (Postfix) with ESMTP id D46777E
        for <linux-ext4@vger.kernel.org>; Thu,  7 Sep 2017 19:31:11 -0400 (EDT)
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v87NVBqv027102
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 7 Sep 2017 19:31:11 -0400
Received: by mail-wm0-f69.google.com with SMTP id p17so637572wmd.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Sep 2017 16:31:11 -0700 (PDT)
In-Reply-To: <20170906192815.orfe2pr6vkakix6u@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thank you for your prompt reply! The Linux kernel we tested against is
Linux 4.13.0-rc6, and the current latest version is 4.13.0-rc7.

We totally agree with your assessment on non-standard flags. As you
pointed out, the O_DIRECT flag is documented in Linux man page but not
in POSIX specification (and we should have checked this). Even for
some documented flags, the POSIX specification does not list their
behavior completely or clearly.

We believe it's beneficial to maintain consistency among different
filesystems, so that developers on one filesystem won't bring the
wrong expectation to work on a different one. The consistency can also
prevent some potential semantic bugs.

Thanks for explaining the matter and we hope our findings could help
with your future development on ext4 :)

Best,
Amy

On Wed, Sep 6, 2017 at 3:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Sep 06, 2017 at 11:58:19AM -0400, Ruoxin Jiang wrote:
>>
>> We are researchers from Columbia University, New York. As part of our
>> current research we have found some semantic discrepancies between
>> ext4 and the POSIX specification/other popular filesystems.
>>
>> We have attached two cases. The first one involves a direct access
>> read starting from file EOF. Ext4 behavior in this case seems to
>> violate the POSIX standard. In directory 2, we discovered that ext4
>> and other popular filesystems (xfs/btrfs/f2fs) return different error
>> codes for the same lseek syscall.
>
> Hi,
>
> Thanks for your report.
>
> First, I commend your use of a relatively new kernel.  The fact that
> you mentioned that some file systems were using iomap means that you
> must be using a relatively new kernel, since iomap was only first
> introduced in 4.8.  Many researchers tend to use far more obsolete
> kernels, so it's nice to see the fact that this was done on a
> relatively new kernel.  That being said, it would have been nice if
> you specified exactly what Linux kernel you did your testing against.
>
> Second, I agree that it is better that file systems on Linux should,
> ideally have behaviour that is made consistent with each other
> whenever possible.  And so changing ext4 to return the same error
> codes or have the same behavior is in general a good thing, all other
> things being equal.  We probably will convert ext4 to use iomap for at
> least O_Direct operations at some point in the future, which will help
> promote this.
>
> From a technical, spec-lawyering, niggling sort of way, I'm not sure
> I'd consider the first case to be a violation of the POSIX
> specification, however.  If you specify an open flag which is not
> specified in POSIX, the behavior of system calls when used against
> that file descriptor might not be fully compliant with the
> specification.  The most obvious example of this is O_NOATIME.  If the
> file descriptor is opened with that flag, then reads will not cause
> atime to change.  This is obviously "in violation" of POSIX, which
> mandates that atime is always modified when a file is read.  But, as
> Charles Dickens once write, sometimes, "the law is an ass".
>
> Similarly, in POSIX 2001, O_CLOEXEC was not yet part of the standard,
> but I don't think anyone would have argued with a straight face that
> because Linux implemented O_CLOEXEC, the fact that a file descriptor
> created with this flag would get closed across an exec meant, ipso
> facto, that Linux was "in violation of the Posix standard".
> Fortunately, for people who might think that, by POSIX 2008, O_CLEXEC
> *was* added to the spec, so that's no longer an issue.  We still
> "violate the POSIX" spec with respect to O_NOATIME, however...
>
> It's for this reason that I would argue that ext4 isn't necessarily
> violating the specification when O_DIRECT is used, because O_DIRECT is
> not defined by POSIX or the Single Unix Specification, and as
> discussed above, non-standard flags can make system calls behave in
> ways that are different from what is specified in POSIX specification.
> (Another example: the O_PATH flag.)
>
> It's still valid to say that ext4 should change to be consistent with
> other file systems, and I agree with the changes you proposed in your
> Readme.md files.  I'm just quibbling about whether or not this can be
> technically considered a "POSIX Violation".
>
> Best regards,
>
>                                         - Ted



-- 
Ruoxin(Amy) Jiang
Columbia University, M.S. Computer Science
347-277-5455
