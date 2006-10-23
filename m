From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 16:55:32 +0200
Message-ID: <20061023145532.GE19623@atrey.karlin.mff.cuni.cz>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061023144824.GK3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48287 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S964909AbWJWOyo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 10:54:44 -0400
To: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061023144824.GK3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Oct 23, 2006  18:31 +0400, Alex Tomas wrote:
> I would make this interface optionally allow the target extent to be
> specified, but if target block == 0 then the kernel is free to do its
> own allocation.
  That's a good idea! I'll change the handling so that if block==0 we
just allocate blocks of given extent as we wish...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
