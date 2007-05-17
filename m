From: Jan Kara <jack@suse.cz>
Subject: Re: ext2/3/4 online defrag
Date: Thu, 17 May 2007 18:11:19 +0200
Message-ID: <20070517161119.GB3230@atrey.karlin.mff.cuni.cz>
References: <1178770799.26695.11.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbXEQQLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 May 2007 12:11:20 -0400
Content-Disposition: inline
In-Reply-To: <1178770799.26695.11.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  Sorry for replying a bit late...

> This is my first post to the list. I want to add online defrag support
> to ext2/3/4 just to scratch an itch.
> 
> I've searched the archives and googled around, and I've come to the
> following conclusions:
> *An offline defrag tool is available but dangerous.
  For original e2defrag - yes. But me (and several other people
independently as I've learnt recently) have written some tools which
should result in something useful. If you're interested, you can join
prefetch-devel@googlegroups.com - it's led by one guy who is doing
defrag and stuff as his google summer of code project.

> *Some patches exist that provide preliminary support for online defrag
> in the ext3 driver, but interest in improving/integrating these patches
> is low.
  The code itself for ext3 is not a big deal. Main problem are kernel
interfaces and I hope to find some time soon to put together some
reasonable proposal for reasonably generic calls...

> *An implementation of an ext* filesystem driver can work with any
> ext2/3/4 filesystem as long as it supports the necessary revision
> (GOOD_OLD_REV or DYNAMIC_REV) and feature flags set in the filesystem.
  Not sure what you mean here...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
