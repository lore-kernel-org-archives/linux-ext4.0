From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] percpu_counter: use local_t and atomic_long_t if
 possible
Date: Tue, 23 Dec 2008 12:43:21 +0100
Message-ID: <1230032601.9487.247.camel@twins>
References: <4936D287.6090206@cosmosbay.com>
	 <20081209214921.b3944687.akpm@linux-foundation.org>
	 <49404925.7090902@cosmosbay.com> <200812121847.06432.rusty@rustcorp.com.au>
	 <49424637.3010107@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Theodore Tso <tytso@mit.edu>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Christoph Lameter <cl@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viefep19-int.chello.at ([62.179.121.39]:60892 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbYLWLnY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 06:43:24 -0500
In-Reply-To: <49424637.3010107@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One think that sprung to mind,..

IFF we're going to implement percpu_counter with local_t and make
local_t this funny tri-counter thing which has its own error, you need
to fix up bdi_stat_error() - it expects to be an upper bound for the
counter error, getting that wrong _will_ cause deadlocks.



