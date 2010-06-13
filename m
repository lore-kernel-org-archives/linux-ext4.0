From: Andi Kleen <andi@firstfloor.org>
Subject: Re: ext4 df free space reporting not reliable?
Date: Sun, 13 Jun 2010 12:34:51 +0200
Message-ID: <20100613103451.GF31464@basil.fritz.box>
References: <20100613093807.GA31407@basil.fritz.box> <69DFE925-D32D-4CAA-B734-545DE0515FCE@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0FMKew (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jun 2010 06:34:52 -0400
Content-Disposition: inline
In-Reply-To: <69DFE925-D32D-4CAA-B734-545DE0515FCE@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Are you creating the files as root?  Sounds like the standard reserved
> blocks behavior that's been around since ext3, ext2, BSD's ufs, etc...

Yes everything is root.

I would expect root df to not report the reservation. Is that not the case?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
