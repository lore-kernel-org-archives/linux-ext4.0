From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Fri, 13 Nov 2009 12:39:55 +0100
Message-ID: <87fx8itzzo.fsf@basil.nowhere.org>
References: <4AFC14D6.7080700@diamondcut.com.br>
	<20091112153017.GA32122@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47687 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZKMLju (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2009 06:39:50 -0500
In-Reply-To: <20091112153017.GA32122@mit.edu> (Theodore Tso's message of "Thu, 12 Nov 2009 10:30:17 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:
>
> I have done a few things to reduce needless disk utilization, such as
> using tmpfs for /tmp and configuring firefox to place its cache in
> /tmp,

OT, but these two together seems rather pointless, could as well
keep it in its own memory then when it's in memory anyways. That will
be faster.

-Andi (who generally disables firefox disk caching)

-- 
ak@linux.intel.com -- Speaking for myself only.
