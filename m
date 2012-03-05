From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: fix race between sync and completed io work
Date: Mon, 5 Mar 2012 10:30:11 -0500
Message-ID: <20120305153011.GB21356@thunk.org>
References: <x49mx81s4zr.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45817 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964942Ab2CEPaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 10:30:13 -0500
Content-Disposition: inline
In-Reply-To: <x49mx81s4zr.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 29, 2012 at 04:29:28PM -0500, Jeff Moyer wrote:
> Hi,
> 
> The following command line will leave the aio-stress process unkillable
> on an ext4 file system (in my case, mounted on /mnt/test)....

Thanks, applied.

					- Ted
