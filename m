From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add comments to definition of ext4_io_end_t
Date: Mon, 5 Mar 2012 10:42:22 -0500
Message-ID: <20120305154222.GD21356@thunk.org>
References: <1330706625-24701-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52955 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2CEPmY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 10:42:24 -0500
Content-Disposition: inline
In-Reply-To: <1330706625-24701-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 08:43:45AM -0800, Curt Wohlgemuth wrote:
> This should make it more clear what this structure is used
> for, and how some of the (mutually exclusive) fields are
> used to keep page cache references.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Thanks, applied.

					- Ted
