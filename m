From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 00/54] e2fsprogs: Add metadata checksumming
Date: Fri, 9 Mar 2012 17:37:28 -0500
Message-ID: <20120309223728.GD5635@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47446 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030207Ab2CIWhj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 17:37:39 -0500
Content-Disposition: inline
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've imported this patch set into a guilt patch series, which makes it
easier for me to work on the patch series and make minor tweaks so
that I can get interim e2fsprogs support up and going (and at least
building and passing the regression test suite) so I can test and play
with the kernel side patches.

People who want to follow along can look here:

	https://github.com/tytso/e2fsprogs-cksum-patch-queue

... or at the read-only git tree which you can find here:

	git://github.com/tytso/e2fsprogs-cksum-patch-queue.git

With these large patch series it's easier for me to make blanket
changes to fix minor annoyances (such as commit descriptions which are
too wide and make "git log" displays hard to follow) or to merge
patches that are too fine grained[1] together.

Open source project management theory says that it's better to ask the
submitter to do all of this work, but given certain special
circumstances in this particular case, I decided to make the cleanup
work that I do publicly visible, as a compromise.  I'll also make some
comments about some of the issues I find (and fix) by replying to the
emails on this mail thread.

This patch series will be maintained so that it can be applied to the
top-most "maint" branch of e2fsprogs.

Darrick, if you have time and would like to make further changes, ping
me off-line and I would be happy to give you write access to the
github tree.

						- Ted
