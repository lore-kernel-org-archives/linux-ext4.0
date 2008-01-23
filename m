From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4-online-defrag-free-space-fragmentation.patch uses
	do_fsync()
Date: Wed, 23 Jan 2008 09:16:14 -0500
Message-ID: <20080123141614.GD29321@mit.edu>
References: <E1JHg4T-0007lQ-8f@closure.thunk.org> <1201097420.9082.5.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57883 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898AbYAWOSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 09:18:55 -0500
Content-Disposition: inline
In-Reply-To: <1201097420.9082.5.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2008 at 08:10:20AM -0600, Dave Kleikamp wrote:
> I'd think you'd want to change the printk text as well.  "defrag: failed
> ext4_force_commit (%d)\n" maybe?

mmm, good catch, thanks.

						- Ted
