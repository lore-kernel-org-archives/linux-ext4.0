From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/11 v3] ext[24]: MBCache rewrite
Date: Mon, 22 Feb 2016 11:31:16 -0500
Message-ID: <20160222163116.GB1215@thunk.org>
References: <1456127301-7702-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36792 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbcBVQbU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 11:31:20 -0500
Content-Disposition: inline
In-Reply-To: <1456127301-7702-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 22, 2016 at 08:48:10AM +0100, Jan Kara wrote:
> Hello,
> 
> since Ted didn't merge the mbcache rewrite patches yet, here is a new version
> of mbcache rewrite series with some improvements from Andreas Grunbacher. Ted,
> can you please pick up this series for the next merge window? Thanks!

I had actually already pulled mbcache2 into ext4.git, but I'll replace
it with your new patch series.

							- Ted
