From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 write performance regression in 3.6-rc1
Date: Fri, 17 Aug 2012 09:40:39 -0400
Message-ID: <20120817134039.GB11439@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060915.GB28786@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com,
	"Shi, Alex" <alex.shi@intel.com>, linux-fsdevel@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45241 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2HQNkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 09:40:42 -0400
Content-Disposition: inline
In-Reply-To: <20120817060915.GB28786@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 17, 2012 at 02:09:15PM +0800, Fengguang Wu wrote:
> Ted,
> 
> I find ext4 write performance dropped by 3.3% on average in the
> 3.6-rc1 merge window. xfs and btrfs are fine.
> 
> Two machines are tested. The performance regression happens in the
> lkp-nex04 machine, which is equipped with 12 SSD drives. lkp-st02 does
> not see regression, which is equipped with HDD drives. I'll continue
> to repeat the tests and report variations.

Hmm... I've checked out the commits in "git log v3.5..v3.6-rc1 --
fs/ext4 fs/jbd2" and I don't see anything that I would expect would
cause that.  The are the lock elimination changes for Direct I/O
overwrites, but that shouldn't matter for your tests which are
measuring buffered writes, correct?

Is there any chance you could do me a favor and do a git bisect
restricted to commits involving fs/ext4 and fs/jbd2?

Many thanks,

						- Ted
