From: Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 16:41:37 -0600
Message-ID: <20070301224137.GA11276@kryten>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35104 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161060AbXCAWln (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2007 17:41:43 -0500
Content-Disposition: inline
In-Reply-To: <20070301142537.b5950cd7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


> That new argument might need to come after "fd" - ARM has funny
> requirements on syscall arg padding and layout.

FYI the 32bit ppc ABI does too, from arch/powerpc/kernel/sys_ppc32.c:

/*
 * long long munging:
 * The 32 bit ABI passes long longs in an odd even register pair.
 */

and the first argument in a function call is in r3.

Anton
