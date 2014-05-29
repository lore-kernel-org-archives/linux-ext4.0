From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: more resize breakage
Date: Thu, 29 May 2014 02:09:02 -0400
Message-ID: <20140529060902.GC25041@thunk.org>
References: <5386C41D.2090006@redhat.com>
 <20140529052733.GD17413@birch.djwong.org>
 <5386C5BF.7080202@redhat.com>
 <20140529060048.GB27499@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38681 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaE2GJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 02:09:07 -0400
Content-Disposition: inline
In-Reply-To: <20140529060048.GB27499@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Darrick, 

I don't think the problem which Eric reported in the head of this
thread is fixed by one of your patches, but you did send some patches
which I think would fix some resize bugs, which are setting on the
ext4 "dev" branch for the next merge window.

It's too late for me to deal with this tonight, but I'll run a quick
check and see if Eric's repro fails with the tip of the ext4 patch
queue.

Eric, thanks for creating this tool; I think it will incredibly
helpful in terms of finding and fixing some of these edge cases.

Cheers,

					- Ted
