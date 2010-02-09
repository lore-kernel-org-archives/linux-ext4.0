From: Jan Kara <jack@suse.cz>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Tue, 9 Feb 2010 17:05:22 +0100
Message-ID: <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
References: <loom.20100204T064311-880@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kailas Joshi <kailas.joshi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60970 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab0BIQFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 11:05:24 -0500
Content-Disposition: inline
In-Reply-To: <loom.20100204T064311-880@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I recently found that in EXT4 with delayed block the Ordered mode does not
> bahave same as in EXT3.
> I found a patch for this at http://lwn.net/Articles/324023/, but it has some
> journal block estimation problem resulting into deadlock.
> 
> I would like to know if it has been solved.
> If not, is it possible to solve it? What are the complexities involved?
  It has not been solved. The problem is that to commit data on transaction
commit (which is what data=ordered mode has historically done), you have to
allocate space for these blocks. But that allocation needs to modify a
filesystem and thus journal more blocks... And that is tricky - we would have
to reserve space in the current transaction for allocation of delayed data.  So
it gets a bit messy...
  Why exactly do you need the old data=ordered guarantees?

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
