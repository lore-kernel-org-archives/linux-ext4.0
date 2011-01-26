From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] block: Create sysfs knobs to override FLUSH/FUA
 support flags
Date: Wed, 26 Jan 2011 10:30:51 +0100
Message-ID: <20110126093051.GA12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126071626.GI27190@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
	shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca,
	jack@suse.cz, snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us.ibm.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, hch@lst.de, josef@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1AZJa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 04:30:57 -0500
Content-Disposition: inline
In-Reply-To: <20110126071626.GI27190@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 11:16:26PM -0800, Darrick J. Wong wrote:
> This patch is the first in a series to refactor the barrier= mount options out
> of the filesystem code.  This patch adds sysfs knobs to disable flush and FUA;
> of course, the automatic default is the safe choice, i.e. to leave them
> enabled.  Obviously, only a seasoned administrator should ever be overriding
> the defaults.

Hmmm... wouldn't it be better to just export flush and fua instead of
ignore_*?  So that the admin can turn things on and off as [s]he seems
fit?  Also, it might be better to export them in a single attribute,
say cache_control or something.  Only subset of the combinations make
sense anyway - none, flush, flush_fua.

Thanks.

-- 
tejun
