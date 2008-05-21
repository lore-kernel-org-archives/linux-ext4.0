From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Wed, 21 May 2008 20:42:18 +0100
Message-ID: <20080521194218.GB26780@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org> <20080521182949.GL8581@mit.edu> <20080521114917.60bf42c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:59568 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbYEUTm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 15:42:57 -0400
Content-Disposition: inline
In-Reply-To: <20080521114917.60bf42c7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton wrote:
> >  And as long as your 100% confident that UPS's will never fail,
> > janitors will never accidentally hit the Emergency Power Office
> > switch, and so on.
> 
> Well.  The product of two very small numbers is...

Another unquantified very small number.

You have a UPS, but the first time you discover it's not wired up
properly is when it fails.

This happened recently in a customer's office...  The UPS power wiring
melted, leaving a big stinking hole, and all the servers went down -
quickly.

Another is misconfiguring the UPS daemon so it continues writing to
disk for 30 minutes until the battery runs down...

Like the chance of two disks going wrong in a RAID at the same
time... that would *never* happen would it?

*tip-toes out of the room*

-- Jamie
