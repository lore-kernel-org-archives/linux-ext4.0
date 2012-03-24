From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 23 Mar 2012 20:13:57 -0700
Message-ID: <20120324031357.GA5690@tassilo.jf.intel.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
 <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab2CXDOL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2012 23:14:11 -0400
Content-Disposition: inline
In-Reply-To: <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The patch only disables the statistics counting, but not the sysfs
> files that will now report bogus statistics.  I don't disagree with
> disabling these stats, but if you are disabling the accounting you
> should also comment out the functions in fs/ext4/super.c that are
> printing out these statistics.

Aware of that -- that is why it was just a RFC.
The choice is between per cpu counters or completely removing them.
I would prefer the later.

-Andi

