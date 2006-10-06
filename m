From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 21:31:33 -0700
Message-ID: <20061005213133.2c4cd82d.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:47004 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750751AbWJFEbg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 00:31:36 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


If you mount the filesystem with `-t ext4dev -o extents' then create some
extenty files, then unount it and then mount it without `-o extents', the
driver will then refuse to create extenty files.

IOW: you need to give it `-o extents' each time.

That seems fairly pointless.  In fact, if I'd created the fs with `mke2fs
-O extents' (which doesn't work at present) then I'd expect it to use
extents from thereon after, without requiring `mount -o extents'.

