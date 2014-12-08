From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 4/10] lib/siphash.c: New file
Date: Mon, 8 Dec 2014 08:16:22 -0500
Message-ID: <20141208131622.GB5142@thunk.org>
References: <20140929191243.GN10150@birch.djwong.org>
 <20141206233200.3175.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45224 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbaLHNQ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Dec 2014 08:16:28 -0500
Content-Disposition: inline
In-Reply-To: <20141206233200.3175.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 06, 2014 at 06:32:00PM -0500, George Spelvin wrote:
> Well, *that* was a rabbit hole.  It seems like an obviously good idea,
> but let's just say that crypto/ is non-obvious.  (No, it didn't take me 2
> months of work; I just got sidetracked a lot because it was discouraging.)
> But now that my cleanup patches there are getting reviewed, I can answer.

Yeah, at this point I think we're better off having our own open-coded
version of siphash.  We have in the past exported the core of a crypto
hash which could be used by both /dev/random and the version in
crypto/ with all of the crypto packaging and overhead, but it's
probably not worth it here --- siphash is much smaller than say, any
of the SHA algorithms.

(The same is true for our use of crc32c, BTW --- if you can
demonstrate on a ramdisk --- or a super fast PCIe attached flash, but
randisks are cheaper --- that there are workloads were we are paying
for overheads caused by the crypto layer, it might make sense to
export the crc32c tables, and have an ext4-specific crc32c function.
OTOH, the main resaon why we probably want to keep on using the
crypto/ is that we can more easily take advantage of hardware
acceleration on some platforms, which wouldn't be the case with
siphash.)

Cheers,

						- Ted
