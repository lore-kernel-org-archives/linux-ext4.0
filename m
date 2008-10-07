From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on 32
 bit architecture
Date: Mon, 6 Oct 2008 23:23:22 -0700
Message-ID: <20081006232322.c383fac5.akpm@linux-foundation.org>
References: <E1KmetO-00053M-5u@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYJGGYY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 02:24:24 -0400
In-Reply-To: <E1KmetO-00053M-5u@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 05 Oct 2008 21:28:10 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:

> The following patch has been sitting in the ext4 patch queue for about
> six weeks.  It was there it was a suspected cause for block allocation
> bug.  As I recall, it we found the true root cause since then, but this
> has stuck around since it's a potential problem.  Andrew has expressed
> concerns that this patch might have performance impacts.

Performace impacts I guess we'll just have to put up with.  iirc I was
thinking that this implementation should be pushed down to a kernel-wide
atomic64_t and then the percpu_counters would just use that type.

