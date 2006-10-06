From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 23:50:17 -0700
Message-ID: <20061005235017.cbc4fdab.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061005215442.310b7792.rdunlap@xenotime.net>
	<20061006055305.GG22010@schatzie.adilger.int>
	<20061005230401.0159e31b.akpm@osdl.org>
	<20061006064103.GJ22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:9403 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932645AbWJFGuX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 02:50:23 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061006064103.GJ22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 6 Oct 2006 00:41:03 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> The big performance win will come with mballoc and delalloc.  CFS has
> been using mballoc for a few years already with Lustre, and IBM + Bull
> did a lot of benchmarking on it.  The reason it isn't in the first set of
> patches is partly a manageability issue, and partly because it doesn't
> directly affect the on-disk format (outside of much better allocation)
> so it isn't critical to get into the first round of changes.  I believe
> Alex is working on a new set of patches right now.

Are you sure that these things will improve allocation much?  Reservations
made a big improvement there.
