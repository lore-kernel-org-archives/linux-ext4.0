From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
Date: Sun, 15 Jul 2007 12:21:21 +0200
Message-ID: <1184494881.5284.92.camel@lappy>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbXGOKVp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jul 2007 06:21:45 -0400
In-Reply-To: <20070713214746.GH23255@mami.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 14:47 -0700, Zach Brown wrote:

> Peter, do you have any interest in seeing how far we can get
> at tracking lock_page()?  I'm not holding my breath, but any little bit
> would probably help.

I ran headfirst into the fact the unlock_page() need not be called by
the same task that did lock_page().

Esp IO-completion interrupts love to unlock pages they did not lock
themselves. Not at all sure that is fixable, it seems to be the nature
of the async structure of the problem :-(
