From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 26 Aug 2010 10:25:36 +0900
Message-ID: <20100826102535.C327.61FB500B@jp.fujitsu.com>
References: <20100826003657.GN4453@thunk.org> <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0HZBZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 21:25:04 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7Q1P3wp018348
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Thu, 26 Aug 2010 10:25:03 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id E6CD345DE63
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 10:25:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 945C845DE6D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 10:25:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5E51BE1800C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 10:25:02 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id A6C9EE08004
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 10:25:01 +0900 (JST)
In-Reply-To: <6B0D8B5D-C576-4DC2-B390-9D1EB8B6A5BA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Aug 2010 18:55:49 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> On 2010-08-25, at 18:36, Ted Ts'o wrote:
> > On Wed, Aug 25, 2010 at 05:39:11PM -0600, Andreas Dilger wrote:
> >> 
> >> The fix to e2fsck for this issue has been around for a long time,
> >> AFAIK.  It was only needed in the kernel while the broken mke2fs was
> >> in wide use, and before a fixed e2fsck was available.
> > 
> > The mke2fs in question was fixed in e2fsprogs 1.37, over five years
> > ago.  Mizuma-san, why are you using such an __ancient__ mke2fs?  It
> > would seem that instead of fixing the kernel, the better thing to do
> > is to fix your version of e2fsprogs.
> 
> I think you are missing the point.  I don't think it matters which mke2fs is in use.  The problem is that ext3_iget() has a workaround for this 5-year-old mke2fs bug that is actively causing a loss of xattr data if lost+found is reallocated.
I used e2fsprogs 1.41. I think this problem isn't mke2fs's problem,
so I agree with Andreas.


Thanks,
Masayoshi

