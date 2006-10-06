From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 20:58:29 -0700
Message-ID: <20061005205829.f6a5b031.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:13973 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751766AbWJFD6f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 23:58:35 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
In-Reply-To: <20061005205526.7fe744f5.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 5 Oct 2006 20:55:26 -0700
Andrew Morton <akpm@osdl.org> wrote:

> You grab Alexandre's kit from http://www.bullopensource.org/ext4/20060926/
> and a plain old `mke2fs -j' gives a filesystem which will mount as ext3 or
> ext4.
> 
> If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> incompatible with the ext3 driver.  Yes?

`mke2fs -O extents' doesn't work.  Should it?
