From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: fix race between
 jbd2_journal_remove_checkpoint and ->j_commit_callback
Date: Tue, 26 Mar 2013 22:56:24 -0400
Message-ID: <20130327025624.GA5861@thunk.org>
References: <1363969123-16852-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56177 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab3C0C4c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 22:56:32 -0400
Content-Disposition: inline
In-Reply-To: <1363969123-16852-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 22, 2013 at 08:18:41PM +0400, Dmitry Monakhov wrote:
> 1) Checkpoint lists are empty so we are shure what jbd2_journal_remove_checkpoint()
>    can not be called under our feets.

One spelling nit: s/shure/sure/

Otherwise, looks good!  I take it you'll be resending an updated set
of patch to deal with the other comments?

Thanks for finding this,

   	    	      	  	- Ted

