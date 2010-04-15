From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Thu, 15 Apr 2010 17:11:33 +0200
Message-ID: <87pr2092e2.fsf@basil.nowhere.org>
References: <4BC57A1D.9080105@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4BC57A1D.9080105@sx.jp.nec.com> (Kazuya Mio's message of "Wed, 14 Apr 2010 17:17:33 +0900")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kazuya Mio <k-mio@sx.jp.nec.com> writes:


> We implemented new two ioctls to allocate preferred blocks using inode PA.
> The old implementation idea is the following (b).
> http://marc.info/?l=linux-ext4&m=124962738211206&w=4

I had to read until patch 3/3 to find out what a "PA" actually is.
It might make the patch descriptions more clearer if it was spelled
out at least once in each.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
