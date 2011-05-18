From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 0/2] Fix sending of a barrier and transaction waiting
	in ext4_sync_file()
Date: Wed, 18 May 2011 10:43:27 -0700
Message-ID: <20110518174327.GB20655@tux1.beaverton.ibm.com>
References: <1305628095-27843-1-git-send-email-jack@suse.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Edward Goggin <egoggin@vmware.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44823 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130Ab1ERRn2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 13:43:28 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4IHMado008176
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:22:36 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4IHhR13831498
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:43:27 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4IHhQlr022870
	for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 13:43:27 -0400
Content-Disposition: inline
In-Reply-To: <1305628095-27843-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 12:28:13PM +0200, Jan Kara wrote:
> 
>   Hi Ted,
> 
>   the two patches below fix ext4_sync_file() to wait for a transaction commit
> properly (return value of jbd2_log_start_commit() is not exactly what
> ext4_sync_file() thinks it is). It also optimizes / fixes sending of a barrier
> in some cases (e.g. in ordered mode with external journal we cannot really
> depend on transaction commit to issue a barrier to fs device because we don't
> seem to add inode to a transaction for overwrites).

Probably a silly nit to pick, but do you mean "flush" instead of "barrier"?

--D
> 
> I already fixed ext3 in this regard some time ago but didn't get to porting the
> patches to ext4. 
> 
> 									Honza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
