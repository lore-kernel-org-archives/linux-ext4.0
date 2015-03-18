From: Beata Michalska <b.michalska@samsung.com>
Subject: Re: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block threshold
 events
Date: Wed, 18 Mar 2015 10:31:01 +0100
Message-ID: <550945D5.4060805@samsung.com>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
 <20150316132843.GA8188@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: lczerner@redhat.com, adilger.kernel@dilger.ca, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31968 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbbCRJbP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2015 05:31:15 -0400
In-reply-to: <20150316132843.GA8188@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/16/2015 02:28 PM, Christoph Hellwig wrote:
> Between this and the recent tmpfs discussion I really think this
> needs to be done in a generic way.  Given that the quota noticiations
> already use netlink general space notifications seem like a very
> sensible extension for them.
> 

First of all, apologies for late response.

I do agree that having a generic solution is the perfect one
though non-trivial. If I understood You correctly, You would
like to have quota being extended to cover the case in subject;
smth similar to xfs project quota and its pqnoenforce mount
option, as this would require disabling enforcing both:
soft and hard limits ?


We could also consider going back to already mentioned,
in another thread, the netlink notification interface proposal,
though this still leaves the problem on how to setup the thresholds
(as it covers only the ENOSPC case).


BR
Beata

