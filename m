From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: ext4_mb_generate_buddy and double-free errors
Date: Thu, 12 Mar 2009 20:32:16 -0700
Message-ID: <6601abe90903122032s41c0d1d3jfc0139c14ada7b0a@mail.gmail.com>
References: <1236904175.731.12.camel@bobble.smo.corp.google.com>
	 <49B9BF09.6010306@redhat.com>
	 <1236914533.731.15.camel@bobble.smo.corp.google.com>
	 <49B9D216.8040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Frank Mayhar <fmayhar@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	mrubin <mrubin@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:30916 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105AbZCMDcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 23:32:20 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n2D3WHFN022256
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 20:32:18 -0700
Received: from rv-out-0506.google.com (rvfb25.prod.google.com [10.140.179.25])
	by zps75.corp.google.com with ESMTP id n2D3WGHn023479
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 20:32:16 -0700
Received: by rv-out-0506.google.com with SMTP id b25so1365551rvf.23
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2009 20:32:16 -0700 (PDT)
In-Reply-To: <49B9D216.8040401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric:

On Thu, Mar 12, 2009 at 8:25 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> Frank Mayhar wrote:
>> On Thu, 2009-03-12 at 21:03 -0500, Eric Sandeen wrote:
>>> Frank Mayhar wrote:
>>>> We're seeing errors like:
>>>> =A0 EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: =
group 3049: 21020 blocks in bitmap, 21529 in gd
>>>>
>>>> Usually after this the system is cleaned and in the process we see=
 many
>>>> "mb_free_blocks: double-free of inode x's block y(bit z in group d=
)".
>>>> (In fact, we see exactly as many of these as the difference betwee=
n the
>>>> group and computed count of free blocks.)
>>>>
>>>> It looks like the bitmap itself is getting messed up somehow, at l=
east
>>>> enough to make the free count disagree with the map itself. =A0Has=
 anyone
>>>> else seen something like this? =A0Any pointers as to where to look=
 for
>>>> potential culprits?
>>> Which kernel, for starters?
>>
>> It's our development kernel, 2.6.26 plus as many of the ext4/jbd2
>> patches as we can comfortably pull in.
>
> which makes it a little tough; can you test on upstream too to see if=
 it
> persists?
>
> At this point you are becoming your own distribution (but I suppose y=
ou
> are used to that) ;)

(sigh) Yes we are.  I've pulled in nearly all the patches up in the
ext4-stable branch through the beginning of Feb.  l looked through
patches in this branch today, and didn't see anything new that seemed
relevant.

Testing on upstream won't work for us, unfortunately.

We're mostly hoping that if anybody else has seen this problem they
can chime in with their experiences.  The generate_buddy code that
encounters this error just resets the group descriptor bb_free to the
value in the bitmap, so it's likely not fatal, but this is our first
exposure to some interesting workloads, so we'd like to nail down the
cause asap.

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
