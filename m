From: Tejun Heo <tj@kernel.org>
Subject: Re: [KNOWN BUGGY RFC PATCH 4/3] block: skip elevator
 initialization for flush requests
Date: Wed, 26 Jan 2011 11:05:37 +0100
Message-ID: <20110126100537.GD12520@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110125204158.GA3013@redhat.com>
 <20110126100322.GC12520@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com, jmoyer@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1AZKGb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 05:06:31 -0500
Content-Disposition: inline
In-Reply-To: <20110126100322.GC12520@htj.dyndns.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 26, 2011 at 11:03:22AM +0100, Tejun Heo wrote:
> Also, it would be great to better describe the lifetime difference
> between the first and the second unions and why it has be organized
> this way (rb_node and completion_data can live together but rb_node
> and flush can't).

Oops, what can't live together are elevator_private* and
completion_data.

Thanks.

-- 
tejun
