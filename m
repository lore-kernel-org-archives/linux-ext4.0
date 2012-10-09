From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: freeze_bdev hangs
Date: Tue, 9 Oct 2012 10:43:27 +0530
Message-ID: <CAD6i1fKRjwaGmOyT9-1=N0zBhXMHkc-vtCj=jKNL+fYpwdqt9A@mail.gmail.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com> <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
 <507319B0.8040202@redhat.com> <CAD6i1fJTsowSKmzxyz6V4xjLQ9y-H6MC1MT-5cOb05EQwP0KEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51672 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2JIFNu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2012 01:13:50 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3207169eek.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 22:13:48 -0700 (PDT)
In-Reply-To: <CAD6i1fJTsowSKmzxyz6V4xjLQ9y-H6MC1MT-5cOb05EQwP0KEg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

>> Anyway, did you try the suggestions I offered to track down your original
>> question about the freeze deadlock?
>
> I am not facing any deadlocks on 2.6.18 but was facing it on 3.x.
> freeze_bdev() and thaw_bdev() work correctly on 2.6.18. I will try it
> again on 3.x and confirm.
>

I tested it on 3.x and freeze_bdev() / thaw_bdev() work correctly. It
turns out I was doing something wrong related to sleeping/locks in the
custom make_request_fn() that caused it to freeze.

> Regards.
