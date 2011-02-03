From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] block: share request flush fields with
 elevator_private
Date: Thu, 3 Feb 2011 10:24:01 +0100
Message-ID: <20110203092401.GA2570@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>, tytso@mit.edu, djwong@us.ibm.com,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	hch@lst.de, josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1BCJYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 04:24:08 -0500
Content-Disposition: inline
In-Reply-To: <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 01, 2011 at 05:46:13PM -0500, Mike Snitzer wrote:
> Flush requests are never put on the IO scheduler.  Convert request
> structure's elevator_private* into an array and have the flush fields
> share a union with it.
> 
> Reclaim the space lost in 'struct request' by moving 'completion_data'
> back in the union with 'rb_node'.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
