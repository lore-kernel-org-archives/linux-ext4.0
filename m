From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Using O_DIRECT in ext4
Date: Tue, 21 Jul 2009 11:38:11 -0500
Message-ID: <4A65EEF3.9090507@redhat.com>
References: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com>	 <4A6538DB.5050202@redhat.com> <6601abe90907210745k3730f74dq62f1fe6539722b4d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Xiang Wang <xiangw@google.com>, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbZGUQiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 12:38:16 -0400
In-Reply-To: <6601abe90907210745k3730f74dq62f1fe6539722b4d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Curt Wohlgemuth wrote:
> On Mon, Jul 20, 2009 at 8:41 PM, Eric Sandeen<sandeen@redhat.com> wrote:
>> Xiang Wang wrote:

>>> For comparison, I did the same experiment on an ext2 partition,
>>> resulting in each file having only 1 extent.
>> Interestinng, not sure I would have expected that.
> 
> Same with us; we're looking into more variables to understand it.

To be more clear, I would not have expected ext2 to deal well with it
either, is more what I meant ;)  I'm not terribly surprised that ext4
gets fragmented.

For the numbers posted, how big were the files (how many 1m chunks were
written?)

Just FWIW; I did something like:

# for I in `seq 1 16`; do dd if=/dev/zero of=testfile$I bs=1M count=16
oflag=direct & done

on a rhel5.4 beta kernel and got:

~5 extents per file on ext4 (per filefrag output)
between 41 and 234 extents on ext2.
~6 extents per file on ext3.
~16 extents per file on xfs

if I created a subdir for each file:

# for I in `seq 1 16`; do mkdir dir$I; dd if=/dev/zero
of=dir$I/testfile$I bs=1M count=16 oflag=direct & done

~5 extents per file on ext4
1 or 2 extents per file on ext2
1 or 2 extents per file on ext3
~16 extents per file on xfs.

-Eric
