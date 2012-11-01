From: "George Spelvin" <linux@horizon.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: 31 Oct 2012 21:05:21 -0400
Message-ID: <20121101010521.893.qmail@science.horizon.com>
References: <20121008024126.GC468@thunk.org>
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: darrick.wong@oracle.com, linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:25108 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755584Ab2KABFX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 21:05:23 -0400
In-Reply-To: <20121008024126.GC468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm currently running with two ext4 patches:

Author: Theodore Ts'o <tytso@mit.edu>
Date: Sun Oct 7 22:18:56 2012 -0400
Subject: ext4: fix metadata checksum calculation for the superblock

Author: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed Oct 17 12:51:30 2012 -0700
Subject: ext4: Don't verify checksums of dx non-leaf nodes during fallback linear scan

They appear to fix real problems.  I notice, that neither of these have
made it into 2.6.5.  Should they be sent to -stable at some point?

I'm not trying to overrule your judgements on the matter, just ensure that
the omission is actually a conscious decision rather than an oversight.
