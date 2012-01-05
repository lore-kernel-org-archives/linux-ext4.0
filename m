From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 take2] jbd2: delete spin_lock(t_handle_lock) inside
 wirte_lock(j_state_lock)
Date: Wed, 4 Jan 2012 22:27:54 -0500
Message-ID: <20120105032754.GD24494@thunk.org>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
 <4EF066F0.5010809@jp.fujitsu.com>
 <20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
 <20111222210007.ca8fb54f.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YBq_=N0Gnky7RhNHhyTybhP1fLB6Fzzp-GLhEy6Lyekw@mail.gmail.com>
 <4EF7BDE2.4000309@jp.fujitsu.com>
 <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34263 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757525Ab2AED15 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 22:27:57 -0500
Content-Disposition: inline
In-Reply-To: <20111226101727.1ca09119.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 26, 2011 at 10:17:27AM +0900, Toshiyuki Okajima wrote:
> Delete all spin_lock(t_handle_lock) statements inside write_lock(j_state_lock) 
> because the critical code sections can be protected by write_lock(j_state_lock)
> only.
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Reported-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

This may be true today, but I'm worried this is going to make the code
more fragile.  The header file include/linux/jbd2.h defines which
fields are protected by which lock.  This patch is going to make those
comments partially obsolete.  We need to make sure the locking
protocol is clearly defined before we go around removing locks.

This is something I would like to do, but we need to make sure the
code remains maintainable in the long run.

					- Ted
