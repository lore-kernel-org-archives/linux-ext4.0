From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Difference in jbd2 behavior between CentOS and Ubuntu while
 unmounting
Date: Tue, 17 May 2016 22:16:22 -0500
Message-ID: <525cbcd6-5115-292f-25a1-3a6c852b4db3@redhat.com>
References: <CAN0j2-ek1iJ_a8ii+sg+kTdjcmZD6jVUHO9SJBbbhfD+5s_CGw@mail.gmail.com>
 <32a9cbf4-4e2d-335c-0603-9639b30e2863@redhat.com>
 <CAN0j2-cp1odcT44ZoeFDGHMF519F2b9Ffa5vc8PJyJfSLcj5-Q@mail.gmail.com>
 <782fe069-c14f-4bae-609e-bbad554cb657@redhat.com>
 <CAN0j2-d_yRF4WwBUKKQTy0LtJbW7X5YKV+NS6=hWuzgTN6BLRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kamran Khan <krkhan@inspirated.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbcERDQZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2016 23:16:25 -0400
In-Reply-To: <CAN0j2-d_yRF4WwBUKKQTy0LtJbW7X5YKV+NS6=hWuzgTN6BLRA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/17/16 9:55 PM, Kamran Khan wrote:
> On Tue, May 17, 2016 at 7:41 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> You may as well try Centos7.2, at least, there are 50+ updates to
>> jbd2 & ext4 since 7.1.  If it still persists we can dig further.
> 
> I am already on CentOS 7.2 with the latest kernel:
> 
>> [root@kakhan-centos ~]# cat /etc/centos-release
>> CentOS Linux release 7.2.1511 (Core)
>> [root@kakhan-centos ~]# uname -r
>> 3.10.0-327.18.2.el7.x86_64

Sigh, ok, your first post said 7.1...  

> I'm trying to understand the difference in jbd2 behavior across Ubuntu
> 14.04 and Centos 7.1. Will appreciate any help.

So which one did you actually test?

-Eric
