From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount
 options
Date: Wed, 26 Jan 2011 13:21:51 +0100
Message-ID: <20110126122151.GN12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
 <20110126093632.GB12520@htj.dyndns.org>
 <20110126104734.GA23245@quack.suse.cz>
 <4D401092.9060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, hch@lst.de, josef@redhat.com
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58092 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1AZMV7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 07:21:59 -0500
Content-Disposition: inline
In-Reply-To: <4D401092.9060009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Wed, Jan 26, 2011 at 07:16:18AM -0500, Ric Wheeler wrote:
> I would also like to suggest that mount is the right time to change
> a per file system behaviour. We have well known paths (add the mount
> options to /etc/fstab) and sys admins understand it.
> 
> If we have to poke a file, what is the suggested mechanism for doing
> this? Another, new script or user space utility that needs to be run
> at mount time for each file system?
> 
> If we did want to deprecate the "barrier" name, I would leave it in
> place and replace it with something meaningful (at mount time!) to
> users like "data_safety" and "no_data_safety" modes :)

With barrier on by default these days, I don't think it's necessary to
fiddle with it too much.  It's not as important as before.  Let's
leave it as it is.  Barrier, flush, it doesn't really matter how it's
called.

In the long run tho, I think filesystems should just always enable
flush/barrier and the fiddling belongs to the block layer.

Thanks.

-- 
tejun
