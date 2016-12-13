From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Filesystem size problem.
Date: Mon, 12 Dec 2016 18:48:44 -0800
Message-ID: <CAEUYfyN373=Eacbu=jL-YPfcmLC0VjvMc++__eVUAJb++gq6Ug@mail.gmail.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
 <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
 <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca> <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
 <7393F8E6-AD83-430E-AE3E-A800DAB91FD3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34079 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752880AbcLMCsq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Dec 2016 21:48:46 -0500
Received: by mail-qk0-f172.google.com with SMTP id q130so103595054qke.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2016 18:48:46 -0800 (PST)
In-Reply-To: <7393F8E6-AD83-430E-AE3E-A800DAB91FD3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2016 at 2:36 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Dec 9, 2016, at 9:35 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>
>> On 12/9/16 2:29 PM, Andreas Dilger wrote:
>>> On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>>>
>>>> I have an ext3 filesystem that will not mount under newer versions of
>>>> the kernel and I hope someone here can help.
>>>>
>>>> Obviously, one solution is "backup and re-create from scratch". I have
>>>> the backups, but I hope that there may be a quicker method to fix the
>>>> issues.
>>>>
>>>> The root issue is that the filesystem is very slightly smaller than
>>>> the allocated space.
>>
>> So the device is now smaller than the filesystem thinks, right?
>>
>>> The filesystem exists on a MDRAID device and I
>>>> think that when I converted the MDRAID to a newer metadata version, it
>>>> truncated the available size, slightly. However, how I got here isn't
>>>> really important, fixing it now is.
>>>
>>> Running "e2fsck -fy" should fix this.  I'd recommend to use the latest
>>> version of e2fsck.
>>
>> Reaslly?  e2fsck can change total blocks in the superblock to accomodate a
>> shrunken device?  That's a new one for me...
>
> Strange, I thought this case was handled properly by e2fsck.
>
> You could probably fix this with:
>
> # debugfs -R "ssv blocks_count 693359326" /dev/md5



"probably"?

How safe or dangerous is this? Does the filesystem have to be unmounted first?

Simon
