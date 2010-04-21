From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: Add a trace point whenever a barrier IO request
	is  sent
Date: Wed, 21 Apr 2010 23:27:27 +0200
Message-ID: <20100421212727.GY27497@kernel.dk>
References: <20100421205626.GA15607@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53281 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0DUV13 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 17:27:29 -0400
Content-Disposition: inline
In-Reply-To: <20100421205626.GA15607@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 21 2010, Darrick J. Wong wrote:
> Simple debugging patch used to watch for barrier requests.  I've been using
> this to watch ext4's barrier=1 behavior.

But barriers are already being logged, if you watch blkparse data, it'll
be RB or WB events. So I don't see what this addition provides that we
don't already have?

-- 
Jens Axboe

