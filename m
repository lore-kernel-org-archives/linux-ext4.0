From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Thu, 10 Apr 2014 11:42:15 -0700
Message-ID: <20140410184215.GA9171@birch.djwong.org>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
 <20140409220320.GC15303@thunk.org>
 <CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
 <20140410135637.GC15925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jon ernst <jonernst07@gmail.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43808 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaDJSmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2014 14:42:22 -0400
Content-Disposition: inline
In-Reply-To: <20140410135637.GC15925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 09:56:37AM -0400, Theodore Ts'o wrote:
> On Thu, Apr 10, 2014 at 12:13:49AM -0400, jon ernst wrote:
> > 
> > Because bigalloc requires cluster-aware bitfield operations, which
> > means we need EXT2_FLAG_64BITS.
> > I see e2image.c creates image always with EXT2_FLAG_64BITS flag. It is
> > safe to do same thing for e4defrag in my opinion. Please correct me if
> > I am wrong.
> 
> Um.... I *think* so.  e4defrag is one of the less well
> tested/maintained parts of e2fsprogs, as well as the kernel-side code
> which supports e4defrag.  I can't think of any reason why there would
> be any 32-bit dependencies in the kernel side code, although someone
> should probably do a quick audit of the e4defrag code to make sure
> it's not using blk_t where it should be using blk64_t, or have other
> 32-bit dependencies.

>From a quick visual inspection and a sparse bitwise check, e4defrag looks 64bit
clean.

--D
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
