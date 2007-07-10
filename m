From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 11:59:49 -0400
Message-ID: <1184083189.3759.15.camel@localhost.localdomain>
References: <20070710121221.5478a1e3@rx8>
	 <1184088605.17636.1.camel@colyt43.site>
	 <1184089232.13379.6.camel@kleikamp.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: coly li <colyli@gmail.com>, "Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56882 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbXGJS7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 14:59:47 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AIxlHr021886
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 14:59:47 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AIxlRw551032
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 14:59:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AIxkGu010728
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 14:59:47 -0400
In-Reply-To: <1184089232.13379.6.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 12:40 -0500, Dave Kleikamp wrote:
> On Wed, 2007-07-11 at 01:30 +0800, coly li wrote:
> > Hi, once we decide to do this, how about storing inode inside the
> > directory ?
> 
> Which directory?
I think Coly is refering to the idea of
store-inode-inside-in-directory-file.

It's one way to implement the dynamic inode table allocation. With it
you don't have system-wide inode tables anymore, but all inode
structures are directly stored in the directory file.

> 
> > IMHO, the latter one is more attractive :-)
> 
> Sounds like a mess to me.  Consider ln and mv.
> 
> > Coly
> 
