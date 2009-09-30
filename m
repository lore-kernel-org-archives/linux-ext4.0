From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: hard lockup, followed by ext4_lookup: deleted inode referenced: 524788
Date: Wed, 30 Sep 2009 12:38:23 -0700
Message-ID: <20090930193823.GA15892@hexapodia.org>
References: <20090928191644.GR12922@hexapodia.org> <20090928202507.GB22733@mit.edu> <20090928212838.GS12922@hexapodia.org> <20090929031308.GB24383@mit.edu> <20090929161250.GX12922@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([64.81.70.185]:46060 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZI3TiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 15:38:20 -0400
Content-Disposition: inline
In-Reply-To: <20090929161250.GX12922@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2009 at 09:12:50AM -0700, Andy Isaacson wrote:
> I'll run memtest86 and check SMART.

The host ran memtest86+ for 8 hours with no errors and the disk isn't
reporting any problems via SMART.

> I would like to get as close to root cause as possible.  I have a
> filesystem image copied away and I'll be attempting to repro the
> failure; this is a test system for a large deployment, so I don't want
> any issues lurking. :)
> 
> Let me know what debug commands you'd like to run.  dumpe2fs output is
> at http://web.hexapodia.org/~adi/tmp/dumpe2fs.out

I'm going to try to reproduce the failure today.  To my untutored eye
the dumpe2fs output looks OK around group 48.

Thanks for any further suggestions,
-andy
