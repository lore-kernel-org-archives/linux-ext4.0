From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] jbd2: fix race between
 jbd2_journal_remove_checkpoint and ->j_commit_callback V2
Date: Wed, 27 Mar 2013 10:16:43 -0400
Message-ID: <20130327141643.GL5861@thunk.org>
References: <20130327025624.GA5861@thunk.org>
 <1364376164-31701-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56353 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3C0OQy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 10:16:54 -0400
Content-Disposition: inline
In-Reply-To: <1364376164-31701-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied on the dev branch for testing.

	       	      	  	 - Ted
