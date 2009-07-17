From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fail to load a journal if it is too short
Date: Fri, 17 Jul 2009 10:42:30 -0400
Message-ID: <20090717144230.GA29100@mit.edu>
References: <1247684717-16662-1-git-send-email-jack@suse.cz> <1247684717-16662-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52924 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933892AbZGQOmd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jul 2009 10:42:33 -0400
Content-Disposition: inline
In-Reply-To: <1247684717-16662-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2009 at 09:05:17PM +0200, Jan Kara wrote:
> Due to on disk corruption, it can happen that journal is too short. Fail
> to load it in such case so that we don't oops somewhere later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
