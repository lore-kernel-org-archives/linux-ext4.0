From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] ext[24]: MBCache rewrite
Date: Mon, 22 Feb 2016 08:56:22 +0100
Message-ID: <20160222075622.GA7791@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <20160219213328.GA2596@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbcBVH4B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 02:56:01 -0500
Content-Disposition: inline
In-Reply-To: <20160219213328.GA2596@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 19-02-16 16:33:28, Ted Tso wrote:
> Thanks, I've applied the your mbcache2 patches to the ext4 tree for
> the next merge window.  Apologies for the delay in getting them reviewed.

Umm, I have sent v2 on Dec 16 with some cleanups from Andreas [1],
furthermore just today I've pushed out v3 with some further improvements
before seeing your email. Can you replace the patches in your tree or
should I just rebase the improvements on whatever you have now in your
tree?

								Honza

[1] http://comments.gmane.org/gmane.comp.file-systems.ext4/51155

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
