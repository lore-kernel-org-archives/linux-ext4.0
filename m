From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Recovery and Journalling
Date: Mon, 18 Mar 2013 11:00:22 -0500
Message-ID: <51473A16.6080405@redhat.com>
References: <CAEUQcehjR7cgmYdTZ5_Yv8VuVAdPsL8i1ido9agmu5CzfknJNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab3CRQBl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Mar 2013 12:01:41 -0400
In-Reply-To: <CAEUQcehjR7cgmYdTZ5_Yv8VuVAdPsL8i1ido9agmu5CzfknJNg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/17/13 7:07 AM, Subranshu Patel wrote:
> This question is related to recovery (fsck and xfs_repair) and journalling.
> 
> I powered off (improper shut down) the system when the IO was
> undergoing on mounted EXT4 filesystem.
> 
> After that I powered on my machine and then used fsck on the unmounted
> filesystem. fsck recovered it.
> 
> There are 2 things which I want to confirm:
> 1. Firstly fsck replays the journal for any unfinished inconsistent writes.

e2fsck replays the journal to produce a consistent set of metadata on the fs

> 2. Secondly it checks/repairs the other filesystem corruption.

Not by default

> Correct my understanding if wrong.
> 
> Consider the above scenario for XFS as well. In XFS, i need to mount
> the filesystem, and this automatically replays the journal. After this
> I again unmount the filesystem and run xfs_repair.

There should be no need to run xfs_repair.

> But in EXT4, i have to run fsck mandatorily before mounting my
> filesystem. 

It's not required.

> Please confirm my understanding.

Basic things first:

In general, journaling is metadata only (leaving aside for now ext3/4's "data=journal" option).

Metadata journaling ensures that if your system crashes or loses power, the contents of the filesystem + the contents of the log can be reassembled to produce a consistent set of metadata for the filesystem.  Note that this does NOT imply no data loss; it only guarantees consistency.

After an unclean shutdown (crash or power loss), the journal is replayed in some manner, to regain consistency.

In ext3 & ext4, boot-time fsck can replay the journal in userspace, and performs no other consistency checks if the filesystem wasn't marked as having encountered a runtime error.  When the filesystem mounts, it finds that the journal is clean (thanks to the prior e2fsck).  If e2fsck is *not* run before mount, then the journal is replayed in the kernel at mount time.

XFS has no userspace journal replay.  It happens only in the kernel at mount time.

There should be no need for an actual fsck (e2fsck/xfs_repair) run on a journaling filesystem after a crash; the whole point of the journal (and associated runtime overhead) is to guarantee consistency post-crash.

The only fundamental administrative difference here is that ext3/4 can have journals replayed either by e2fsck or by the kernel during mount; xfs's journal is only replayed by the kernel at mount time.

-Eric
