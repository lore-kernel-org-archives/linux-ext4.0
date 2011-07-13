From: Tao Ma <tm@tao.ma>
Subject: Re: [stable] [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in journal_commit_transaction.
Date: Wed, 13 Jul 2011 10:10:03 +0800
Message-ID: <4E1CFE7B.9000305@tao.ma>
References: <1310467431-23108-1-git-send-email-tm@tao.ma> <20110712155517.GA6696@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, stable@kernel.org,
	Vivek Goyal <vgoyal@redhat.com>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44598 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757420Ab1GMCKU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jul 2011 22:10:20 -0400
In-Reply-To: <20110712155517.GA6696@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/12/2011 11:55 PM, Greg KH wrote:
> On Tue, Jul 12, 2011 at 06:43:51PM +0800, Tao Ma wrote:
>> This only affects .37 and .38 since Jens' new plug patches are included
>> in .39 and the bug is removed as a side effect. But I think it is needed
>> anyway for the stable. And RHEL6 needs this also I guess.
> 
> Both the .37 and .38-stable kernel trees are end-of-life and not having
> any more releases, so there's no tree for these to be applied too,
> sorry.
Fine. Since RHEL6 still has this problem(not sure SLES has this problem
or not), I may add a bug in redhat's bugzilla.

Thanks
Tao
