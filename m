From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] percpu_counter: use local_t and atomic_long_t if possible
Date: Thu, 25 Dec 2008 23:56:58 +1030
Message-ID: <200812252356.59595.rusty@rustcorp.com.au>
References: <4936D287.6090206@cosmosbay.com> <49424637.3010107@cosmosbay.com> <1230032601.9487.247.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <cl@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:46243 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYLYN1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2008 08:27:06 -0500
In-Reply-To: <1230032601.9487.247.camel@twins>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 23 December 2008 22:13:21 Peter Zijlstra wrote:
> One think that sprung to mind,..
> 
> IFF we're going to implement percpu_counter with local_t and make
> local_t this funny tri-counter thing which has its own error, you need
> to fix up bdi_stat_error() - it expects to be an upper bound for the
> counter error, getting that wrong _will_ cause deadlocks.

It's OK: local_add_return() can't have error; that's why the trival
implementation disables interrupts around it.

Hope that helps,
Rusty.
