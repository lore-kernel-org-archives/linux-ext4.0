Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbeK1PQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 10:16:08 -0500
Date: Tue, 27 Nov 2018 23:15:55 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Message-ID: <20181128041555.GE31885@thunk.org>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <vb31df-25g.ln1@banana.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vb31df-25g.ln1@banana.localnet>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote:
> Corrupted inodes - always directory, not touched at least year or
> more for writing. Something wrong when updating atime?

We're not sure.  The frustrating thing is that it's not reproducing
for me.  I run extensive regression tests, and I'm using 4.19 on my
development laptop without notcing any problems.  If I could reproduce
it, I could debug it, but since I can't, I need to rely on those who
are seeing the problem to help pinpoint the problem.

I'm trying to figure out common factors from those people who are
reporting problems.

(a) What distribution are you running (it appears that many people
reporting problems are running Ubuntu, but this may be a sampling
issue; lots of people run Ubuntu)?  (For the record, I'm using Debian
Testing.)

(b) What hardware are you using?  (SSD?  SATA-attached?
NVMe-attached?)

(c) Are you using LVM?  LUKS (e.g., disk encrypted)?

(d) are you using discard?  One theory is a recent discard change may
be in play.   How do you use discard?   (mount option, fstrim, etc.)

      	      	     	     		- Ted
