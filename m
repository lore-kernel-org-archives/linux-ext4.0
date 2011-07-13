From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in
 journal_commit_transaction.
Date: Wed, 13 Jul 2011 04:17:55 +0200
Message-ID: <20110713021755.GC10750@kroah.com>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
 <20110712155517.GA6696@kroah.com>
 <4E1CFE7B.9000305@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, stable@kernel.org,
	Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52364 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992Ab1GMCS3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2011 22:18:29 -0400
Content-Disposition: inline
In-Reply-To: <4E1CFE7B.9000305@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 13, 2011 at 10:10:03AM +0800, Tao Ma wrote:
> On 07/12/2011 11:55 PM, Greg KH wrote:
> > On Tue, Jul 12, 2011 at 06:43:51PM +0800, Tao Ma wrote:
> >> This only affects .37 and .38 since Jens' new plug patches are included
> >> in .39 and the bug is removed as a side effect. But I think it is needed
> >> anyway for the stable. And RHEL6 needs this also I guess.
> > 
> > Both the .37 and .38-stable kernel trees are end-of-life and not having
> > any more releases, so there's no tree for these to be applied too,
> > sorry.
> Fine. Since RHEL6 still has this problem(not sure SLES has this problem
> or not), I may add a bug in redhat's bugzilla.

Ok, but neither RHEL6 or SLES11 is based on .37 or .38, so it might not
be relevant for them either.

greg k-h
