From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support features in larger inode
Date: Fri, 13 Jul 2007 14:47:46 -0700
Message-ID: <20070713214746.GH23255@mami.zabbo.net>
References: <1183275482.4010.133.camel@localhost.localdomain> <20070710163247.5c8bfa3f.akpm@linux-foundation.org> <20070713020529.1486491f.akpm@linux-foundation.org> <1184333621.20032.85.camel@twins> <20070713121259.20066d5b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:49033 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbXGMVtF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2007 17:49:05 -0400
Content-Disposition: inline
In-Reply-To: <20070713121259.20066d5b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> I fear the consequences of this change :(

I love it.  In the past I've lost time by working with patches which
didn't quite realize that ext3 holds a transaction open during
->direct_IO.

> Oh well, please keep it alive, maybe beat on it a bit, resend it
> later on?

I can test the patch to make sure that it catches mistakes I've made in
the past.  Peter, do you have any interest in seeing how far we can get
at tracking lock_page()?  I'm not holding my breath, but any little bit
would probably help.

- z
