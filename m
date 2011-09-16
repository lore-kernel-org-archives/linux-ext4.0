From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] ext4: Prevent stack overrun in ext4_file_open when recording last known mountpoint
Date: Fri, 16 Sep 2011 10:54:35 -0700
Message-ID: <m239fwfk4k.fsf@firstfloor.org>
References: <20110915231645.GE12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39125 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1IPRyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 13:54:37 -0400
In-Reply-To: <20110915231645.GE12086@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Thu, 15 Sep 2011 16:16:45 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <djwong@us.ibm.com> writes:


> Writing stack variables into the superblock doesn't sound like a great idea, so
> use strncpy instead.

This means you can end up with a non 0 terminated path in the
superblock, which could confuse programs.

Better use strlcpy()

strncpy is usually a bad idea, it's semantics overall are quite
bogus and it's also inefficient because it always fills.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
