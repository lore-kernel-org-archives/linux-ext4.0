From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2/3/4 online defrag
Date: Wed, 9 May 2007 22:24:09 -0700
Message-ID: <20070510052409.GB6375@schatzie.adilger.int>
References: <1178770799.26695.11.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47609 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbXEJFYM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 May 2007 01:24:12 -0400
Content-Disposition: inline
In-Reply-To: <1178770799.26695.11.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  21:19 -0700, Eric wrote:
> This is my first post to the list. I want to add online defrag support
> to ext2/3/4 just to scratch an itch.
> 
> I've searched the archives and googled around, and I've come to the
> following conclusions:
> *An offline defrag tool is available but dangerous.

Yes, old and dangerous.

> *Some patches exist that provide preliminary support for online defrag
> in the ext3 driver, but interest in improving/integrating these patches
> is low.

I don't think that is true.  Takashi Sato is actively working on online
defrag, and patches are posted regularly to the linux-ext4 mailing list.

I'd recommend that any work being done be spent in improving those
patches instead of starting from scratch.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
