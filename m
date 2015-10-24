From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
 insert range
Date: Fri, 23 Oct 2015 21:22:02 -0400
Message-ID: <20151024012202.GH7917@thunk.org>
References: <1445501761-14528-1-git-send-email-jack@suse.com>
 <1445501761-14528-4-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	ross.zwisler@linux.intel.com, willy@linux.intel.com
To: Jan Kara <jack@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41814 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbbJXKve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:34 -0400
Content-Disposition: inline
In-Reply-To: <1445501761-14528-4-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 22, 2015 at 10:15:55AM +0200, Jan Kara wrote:
> Current code implementing FALLOC_FL_COLLAPSE_RANGE and
> FALLOC_FL_INSERT_RANGE is prove to races with buffered writes and page

Minor nit:

s/prove/prone/

				- Ted
