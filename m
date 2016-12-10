From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Filesystem size problem.
Date: Fri, 9 Dec 2016 21:27:07 -0800
Message-ID: <CAEUYfyMy72M=PPA9wRKpppQOrzWG_NsVR7QUk8RMkP9MY2-Z7w@mail.gmail.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
 <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
 <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca> <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35316 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbcLJF1I (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Dec 2016 00:27:08 -0500
Received: by mail-qk0-f180.google.com with SMTP id n204so37880754qke.2
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2016 21:27:08 -0800 (PST)
In-Reply-To: <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 9, 2016 at 8:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 12/9/16 2:29 PM, Andreas Dilger wrote:
>> On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>>
>>> I have an ext3 filesystem that will not mount under newer versions of
>>> the kernel and I hope someone here can help.
>>>
>>> Obviously, one solution is "backup and re-create from scratch". I have
>>> the backups, but I hope that there may be a quicker method to fix the
>>> issues.
>>>
>>> The root issue is that the filesystem is very slightly smaller than
>>> the allocated space.
>
> So the device is now smaller than the filesystem thinks, right?

Yes, I got that the wrong way round in my original email. The device
is very slightly smaller than the filesystem.


Simon
