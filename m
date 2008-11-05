From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Wed, 05 Nov 2008 16:10:12 -0700
Message-ID: <20081105231012.GJ3184@webber.adilger.int>
References: <20081104161024.GC28058@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43048 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYKEXK0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 18:10:26 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mA5NAKpk013159
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 15:10:20 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K9V00L01UHS9S00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 05 Nov 2008 15:10:20 -0800 (PST)
In-reply-to: <20081104161024.GC28058@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 04, 2008  11:10 -0500, Josef Bacik wrote:
> somebody does a sync write or an fsync() traditionally we would sleep for 1
> jiffies, which depending on the value of HZ could be a significant amount of
> time compared to how long it takes to commit a transaction to the underlying
> storage.  With this patch instead of sleeping for a jiffie, we check to see if
> the amount of time this transaction has been running is less than the average
> commit time, and if it is we sleep for the delta using schedule_hrtimeout to
> give us a higher precision sleep time.  This greatly benefits high end storage
> where you could end up sleeping for longer than it takes to commit the
> transaction and therefore sitting idle instead of allowing the transaction to
> be committed by keeping the sleep time to a minimum so you are sure to always
> be doing something.

There was no reply to my previous comments about making the maximum sleep
time be a fixed value (e.g. 15ms) instead of having it arbitrarily based
on the jiffies value, which may change between 1ms and 10ms.

I don't object to this being included in ext4, but I suspect it could do
even better, or at least be more consistent than depending on the HZ value.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

