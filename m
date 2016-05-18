From: Kamran Khan <krkhan@inspirated.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while unmounting
Date: Tue, 17 May 2016 19:55:14 -0700
Message-ID: <CAN0j2-d_yRF4WwBUKKQTy0LtJbW7X5YKV+NS6=hWuzgTN6BLRA@mail.gmail.com>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
	<32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
	<CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
	<782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33764 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbcERCzP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 22:55:15 -0400
Received: by mail-vk0-f50.google.com with SMTP id z184so44751390vkg.0
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 19:55:14 -0700 (PDT)
In-Reply-To: <782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2016 at 7:41 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> You may as well try Centos7.2, at least, there are 50+ updates to
> jbd2 & ext4 since 7.1.  If it still persists we can dig further.

I am already on CentOS 7.2 with the latest kernel:

> [root@kakhan-centos ~]# cat /etc/centos-release
> CentOS Linux release 7.2.1511 (Core)
> [root@kakhan-centos ~]# uname -r
> 3.10.0-327.18.2.el7.x86_64

>> On Tue, May 17, 2016 at 7:17 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>>> On 5/17/16 7:46 PM, Kamran Khan wrote:
>>>> I'm trying to understand the difference in jbd2 behavior across Ubuntu
>>>> 14.04 and Centos 7.1. Will appreciate any help.
>>>
>>> For starters, what kernel versions are those?  (I know what centos
>>> is, "3.10.0" with updates, which I can check out, but I have no idea
>>> what might be in the Ubuntu distro)
>>>
>>> -Eric
-- 
Kamran.

http://inspirated.com/
