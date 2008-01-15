From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Date: Tue, 15 Jan 2008 13:15:33 +0000
Message-ID: <20080115131533.GA5766@infradead.org>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60172 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYAONPi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2008 08:15:38 -0500
Content-Disposition: inline
In-Reply-To: <20080115030441.a0270609.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2008 at 03:04:41AM -0800, Andrew Morton wrote:
> I'm wondering about the real value of this change, really.
> 
> In any decent environment, people will fsck their ext3 filesystems during
> planned downtime, and the benefit of reducing that downtime from 6
> hours/machine to 2 hours/machine is probably fairly small, given that there
> is no service interruption.  (The same applies to desktops and laptops).
> 
> Sure, the benefit is not *zero*, but it's small.  Much less than it would
> be with ext2.  I mean, the "avoid unplanned fscks" feature is the whole
> reason why ext3 has journalling (and boy is that feature expensive during
> normal operation).
> 
> So...  it's unobvious that the benefit of this feature is worth its risks
> and costs?

They won't fsck in planned downtimes.  They will have to use fsck when
the shit hits the fan and they need to.   Not sure about ext3, but big
XFS user with a close tie to the US goverment were concerned about this
case for really big filesystems and have sponsored speedup including
multithreading xfs_repair.  I'm pretty sure the same arguments apply
to ext3, even if the filesystems are a few magnitudes smaller.

> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
