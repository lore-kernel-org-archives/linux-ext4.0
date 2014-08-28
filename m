From: Liwei <xieliwei@gmail.com>
Subject: Re: Recovering from a damaged root inode
Date: Fri, 29 Aug 2014 06:53:24 +0800
Message-ID: <CAPE0SYw+5OLTVG-tq4rGgEh_2HRkANNsP4mqZF_UOK_76HEfAQ@mail.gmail.com>
References: <CAPE0SYxva9AkaynNDofObS-U5VW7RYW8io+N9Pz+6jVsCody8A@mail.gmail.com>
 <20140828121637.GA3043@thunk.org> <CAPE0SYzRsYFQ9WrLvRzqABXVzRVshhgSK_q5rb+AgEZGQ_NE5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54393 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaH1Wxq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2014 18:53:46 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so1417125wgh.7
        for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2014 15:53:44 -0700 (PDT)
In-Reply-To: <CAPE0SYzRsYFQ9WrLvRzqABXVzRVshhgSK_q5rb+AgEZGQ_NE5A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 29 August 2014 01:19, Liwei <xieliwei@gmail.com> wrote:
> Hi Ted,
>     Thanks for the response! Responses in-line.
>
====SNIP====
>> Finally, this error is one was caused by your using fsck -n:
>>
>>> Illegal triple indirect block (3637063325) in inode 1065.  IGNORED.
>>> Error while iterating over blocks in inode 1065: Illegal triply
>>> indirect block found
>>
>> There was an illegal indirect bock in inode 1065, which wasn't fixed
>> because of e2fsck -n.  Unfortunately, this caused the scan to get
>> aborted, because the unfixed error caused the inode iterator to fail.
>> We could try to fix things up to make e2fsck -n recover more cleanly
>> in the face of errors caused by not fixing previously found errors,
>> but that hasn't been something that's been high priority.  (If someone
>> would like to improve e2fsck in this regard, please send patches.)
>
====SNIP====
>> More generally, it looks like part of your inode table got smashed.
>
> That sounds bad. From my limited understanding of ext4's structure,
> each block group has its own inode table, right? Or is the inode table
> global? What are my chances of recovering from this?
>

I decided to make a snapshot and tried running fsck.ext4 -y.

Currently, this just flew by my screen:
Inode 117911, i_size is 10327091671466843186, should be 0.  Fix? yes

Inode 117911, i_blocks is 123836699223379, should be 0.  Fix? yes

Inode 117841 has a bad extended attribute block 3239803245.  Clear? yes

Inode 117841 has illegal block(s).  Clear? yes

Every single inode before that was erroneous. That means they're data
somehow mistaken as inodes, aren't they?

Liwei
