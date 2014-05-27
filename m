From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] quota: protect Q_GETFMT by dqonoff_mutex
Date: Tue, 27 May 2014 03:12:19 -0700
Message-ID: <20140527101219.GA28035@infradead.org>
References: <537DD5BA.1050105@gmail.com>
 <538464AD.6050407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaE0KMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 06:12:19 -0400
Content-Disposition: inline
In-Reply-To: <538464AD.6050407@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 27, 2014 at 06:10:53PM +0800, Niu Yawei wrote:
> Remove dqptr_sem to make quota code scalable (but kept in struct
> quota_info to keep kernel ABI unchanged):

There is not stable kernel ABI to be kept, please adjust your patch for
that.

