From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] ext4: flush journal when switching from journal
 data mode
Date: Fri, 30 Dec 2011 09:57:56 -0500
Message-ID: <20111230145756.GB29547@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com>
 <20111228185643.GD12370@thunk.org>
 <20111229210153.GN8233@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43570 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab1L3O6A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Dec 2011 09:58:00 -0500
Content-Disposition: inline
In-Reply-To: <20111229210153.GN8233@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 29, 2011 at 01:01:53PM -0800, Darrick J. Wong wrote:
> > It's necessary to flush the journal when switching away from
> > data=journal mode.  This is because there are no revoke records when
> > we are data blocks are journalled,
> 
> Minor nit, but did you mean "when data blocks are journalled" ?

Thanks, I've made this fix in commit description.

	     	       	      - Ted
