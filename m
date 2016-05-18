From: Kamran Khan <krkhan@inspirated.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while unmounting
Date: Tue, 17 May 2016 19:35:06 -0700
Message-ID: <CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
	<32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35955 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbcERCfI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 22:35:08 -0400
Received: by mail-vk0-f42.google.com with SMTP id s184so44215882vkb.3
        for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 19:35:07 -0700 (PDT)
In-Reply-To: <32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yup, the kernel versions are drastically different. It's 3.10 vs 4.2.

The problem on 3.10 though is, while jbd2 holds on to the unmounted
device I cannot even rmmod jbd2 or ext4 *even if no other ext
filesystems are mounted*. That lock makes it all but impossible to do
anything with the block device.

On Tue, May 17, 2016 at 7:17 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/17/16 7:46 PM, Kamran Khan wrote:
>> I'm trying to understand the difference in jbd2 behavior across Ubuntu
>> 14.04 and Centos 7.1. Will appreciate any help.
>
> For starters, what kernel versions are those?  (I know what centos
> is, "3.10.0" with updates, which I can check out, but I have no idea
> what might be in the Ubuntu distro)
>
> -Eric



-- 
Kamran.

http://inspirated.com/
