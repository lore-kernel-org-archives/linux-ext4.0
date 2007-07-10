From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 14:09:05 -0500
Message-ID: <1184094545.13379.20.camel@kleikamp.austin.ibm.com>
References: <20070710121221.5478a1e3@rx8>
	 <1184088605.17636.1.camel@colyt43.site>
	 <1184089232.13379.6.camel@kleikamp.austin.ibm.com>
	 <1184083189.3759.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: coly li <colyli@gmail.com>, "Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50249 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbXGJTJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 15:09:07 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AJAIsw013951
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 15:10:18 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AJ96ig517878
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 15:09:06 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AJ96WO030363
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 15:09:06 -0400
In-Reply-To: <1184083189.3759.15.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 11:59 -0400, Mingming Cao wrote:
> On Tue, 2007-07-10 at 12:40 -0500, Dave Kleikamp wrote:
> > On Wed, 2007-07-11 at 01:30 +0800, coly li wrote:
> > > Hi, once we decide to do this, how about storing inode inside the
> > > directory ?
> > 
> > Which directory?
> I think Coly is refering to the idea of
> store-inode-inside-in-directory-file.
> 
> It's one way to implement the dynamic inode table allocation. With it
> you don't have system-wide inode tables anymore, but all inode
> structures are directly stored in the directory file.

Assuming you mean the parent directory?  An inode isn't tied to a
specific parent.

	ln dir1/file1 dir2/
	mv dir1/file1 dir3/
	rmdir dir1

What is happens to the inode?  I really don't think that the directory
is the right place to store an inode.
-- 
David Kleikamp
IBM Linux Technology Center
