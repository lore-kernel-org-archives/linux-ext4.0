From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Date: Tue, 14 Apr 2009 18:43:03 +0900
Message-ID: <20090414094303.GA10129@localhost.localdomain>
References: <20090414073631.GA4145@localhost.localdomain> <20090414074356.GC398@duck.suse.cz> <20090414093545.GA10092@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:21127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZDNJnJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 05:43:09 -0400
Content-Disposition: inline
In-Reply-To: <20090414093545.GA10092@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 14, 2009 at 06:35:45PM +0900, Akinobu Mita wrote:
> On Tue, Apr 14, 2009 at 09:43:57AM +0200, Jan Kara wrote:
> >   Thanks for the patch but I already have this patch in my quota tree from
> > Dan Carpenter...
> 
> Oh, I should have checked your tree.
> BTW, JFS still have same problem in jfs_quota_write() 

It's already fixed in JFS tree...
