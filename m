From: Terry <td3201@gmail.com>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Sun, 9 Sep 2012 21:53:25 -0500
Message-ID: <CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
	<20120910024709.GA3439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46420 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069Ab2IJCx0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 22:53:26 -0400
Received: by lagy9 with SMTP id y9so804162lag.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 19:53:25 -0700 (PDT)
In-Reply-To: <20120910024709.GA3439@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 9, 2012 at 9:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Sep 09, 2012 at 09:34:10PM -0500, Terry wrote:
>>
>> As the subject says, we have a 15 TB fsck drive that won't mount with
>> these errors:
>>
>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): ext4_check_descriptors:
>> Inode bitmap for group 3200 not in group (block 4161027887)!
>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): group descriptors corrupted!
>
> These indicate a very basic file system corruption where the block
> group descriptors are corrupted.  E2fsck will complain immediately
> upon seeing this sort of fs inconsistency, and the first thing it will
> try to do is fix it.
>
>> We did a proactive fsck on Tuesday of last week because it was
>> starting to give filesystem errors. It ran through and mounted fine.
>>
>> The filesystem lives on an equallogic SAN spread across 36 drives.
>> Could this be something with the physical layer or is it not abnormal
>> to have to run multiple rounds of fsck to fully fix an issue?
>
> This is most probably a hardware problem; normally e2fsck will fix
> file system corruptions (and certainly problems such as corrupt block
> group scriptors) in a single pass.  If e2fsck finished and the file
> system mounted fine last week, and now you're getting this kind of
> error, it basically screams some kind of physical layer problem, or
> perhaps a bad hard drive, or perhaps the SAN disk is getting
> incorrectly written to by some other system, etc.
>
>                                      - Ted

Thanks for the reply.  It is part of a RHEL cluster but we did not
have any situations where multiple systems mounted the filesystem.  It
is a an old SAN so perhaps we have a physical issue. We'll see what it
happens with this pass.
