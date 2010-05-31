From: Christoph Hellwig <hch@lst.de>
Subject: Re: ext2 issues with xfstests 113
Date: Mon, 31 May 2010 20:01:01 +0200
Message-ID: <20100531180101.GA32160@lst.de>
References: <20100531094625.GA10283@lst.de> <20100531175747.GD5334@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:53412 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0EaSBD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 14:01:03 -0400
Content-Disposition: inline
In-Reply-To: <20100531175747.GD5334@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 31, 2010 at 07:57:47PM +0200, Jan Kara wrote:
>   Are you able to reproduce this? Because for me ext2 runs went just
> fine...

I've done a couple of runs both on current mainline and the 2.6.34
based XFS tree and they all show this problem.

