From: Jason Pepas <jasonpepas@gmail.com>
Subject: Re: [Libguestfs] mkfs.ext2 succeeds despite nbd write errors?
Date: Sat, 7 Nov 2015 17:47:22 -0600
Message-ID: <CALuDM+Btx6qLbH_1UcxYLKwVofZD1m=ha_1oYQOkgZctDSMu5A@mail.gmail.com>
References: <CALuDM+AtyUUMFcdTOocxCw9BxQ4PBx5aeYVYwmy_UErh1MZjww@mail.gmail.com>
	<20151107110354.GM1908@redhat.com>
	<CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
	<20151107210203.GW29330@redhat.com>
	<CALuDM+CAE1g8-9g9_72hU3xcQnA5k8QTkSQj4rjHh2tHc8mgLw@mail.gmail.com>
	<20151107232001.GX29330@redhat.com>
	<CALuDM+DHATW=KvM0XeREygrA5z=6U1n+UyBqv8juXx7mXHa4UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34041 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbKGXrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Nov 2015 18:47:23 -0500
Received: by obbza9 with SMTP id za9so118021527obb.1
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2015 15:47:22 -0800 (PST)
In-Reply-To: <CALuDM+DHATW=KvM0XeREygrA5z=6U1n+UyBqv8juXx7mXHa4UA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 7, 2015 at 5:25 PM, Jason Pepas <jasonpepas@gmail.com> wrote:
> On Sat, Nov 7, 2015 at 5:20 PM, Richard W.M. Jones <rjones@redhat.com> wrote:
>>
>> I'll leave the rest to the true experts on the ext4 mailing list.
>
> Thanks for you help!  I'll move the rest of this discussion to their
> mailing list.

Hi ext4 folk,

I ran into a situation where mke2fs was writing to faulty block device
(an nbd server), but mke2fs didn't report a problem, so I didn't know
that my newly created filesystem was corrupted.

I've traced this down to the return value not being checked on the
final fsync() call.

I've confirmed locally that checking this return value and passing it
up the call stack will correctly cause mke2fs to exit non-zero.

I've created a pull request on github here:
https://github.com/tytso/e2fsprogs/pull/4

Thanks,
Jason Pepas
