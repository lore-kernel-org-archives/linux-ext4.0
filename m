From: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 08:48:25 +0200 (CEST)
Message-ID: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Andi Kleen" <andi@firstfloor.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Ingo Molnar" <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Linux Kernel" <linux-kernel@vger.kernel.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>,
	"Linux Ext4" <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:58577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0IPGs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Sep 2010 02:48:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> When the dest and the src do overlap and the memory area is large, memmove
> of
> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
> file
> deletion performance. This patch improved the performance of memmove on
> x86_64
> by using __memcpy_bwd() instead of byte copy when doing large memory area
> copy
> (len > 64).


I still don't understand why you don't simply use a backwards
string copy (with std) ? That should be much simpler and
hopefully be as optimized for kernel copies on recent CPUs.

-Andi


