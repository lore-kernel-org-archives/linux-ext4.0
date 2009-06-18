From: Theodore Tso <tytso@mit.edu>
Subject: Re: Some 64-bit tests
Date: Thu, 18 Jun 2009 17:11:12 -0400
Message-ID: <20090618211112.GE7183@mit.edu>
References: <18887.1244469441@gamaville.dokosmarshall.org> <20090608201037.GB23723@skywalker> <14597.1244517228@gamaville.dokosmarshall.org> <20090610181320.GA6953@mit.edu> <20090611055006.GA8073@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53224 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbZFRVLU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jun 2009 17:11:20 -0400
Content-Disposition: inline
In-Reply-To: <20090611055006.GA8073@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 11, 2009 at 11:20:06AM +0530, Aneesh Kumar K.V wrote:
> 
> I already have a RFC patch which Nick actually tested. It is giving 32MB
> extents, which is expected because the max order in buddy cache is
> blocksize_bits + 1. I have a Fixme in there regarding scaling the start
> block which was hoping to fix soon.

FYI, this patch seems to cause the system to lock up on umount when
running xfstests #135.

I'm removing it from the unstable patch queue for now; do you have an
update for this patch?

						- Ted
