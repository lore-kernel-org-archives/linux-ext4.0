From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 12:40:32 -0500
Message-ID: <1184089232.13379.6.camel@kleikamp.austin.ibm.com>
References: <20070710121221.5478a1e3@rx8>
	 <1184088605.17636.1.camel@colyt43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: coly li <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43163 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbXGJRke (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 13:40:34 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AHeYsS005191
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:40:34 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AHeYU1514574
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:40:34 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AHeX17009177
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:40:33 -0400
In-Reply-To: <1184088605.17636.1.camel@colyt43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-11 at 01:30 +0800, coly li wrote:
> Hi, once we decide to do this, how about storing inode inside the
> directory ?

Which directory?

> IMHO, the latter one is more attractive :-)

Sounds like a mess to me.  Consider ln and mv.

> Coly

-- 
David Kleikamp
IBM Linux Technology Center
