From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Mon, 24 Jun 2013 00:06:57 -0700
Message-ID: <20130624070656.GA20166@infradead.org>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Namjae Jeon <linkinjeon@gmail.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3FXHHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Jun 2013 03:07:09 -0400
Content-Disposition: inline
In-Reply-To: <20130624024459.GJ29376@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 24, 2013 at 12:44:59PM +1000, Dave Chinner wrote:
> various DVR companies shipping equivalent ioctl-based functionality
> for XFS filesystems to both insert and remove chunks in video
> streams, but I've never been able to find the code for it anywhere.

Samsung does this, also for UDF.  Namjae, could you please submit these
two as well, including a proper VFS interface?

