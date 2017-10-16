From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] e2fsprogs: Fixes typos in code and docs.
Date: Sun, 15 Oct 2017 23:23:36 -0400
Message-ID: <20171016032336.lj3qfb43kg2yhrx5@thunk.org>
References: <20171014184456.17602-1-sebras@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sebastian Rasmussen <sebras@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49798 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751650AbdJPDXi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Oct 2017 23:23:38 -0400
Content-Disposition: inline
In-Reply-To: <20171014184456.17602-1-sebras@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 14, 2017 at 08:44:53PM +0200, Sebastian Rasmussen wrote:
> While reading the manpage for resize2fs I came a across a typo,
> so I fixed it along with other typos in user-visible error
> messages and docs. The next patch addresses non-user visible
> typos, i.e. in code comments or docs aimed at developers.
> 
> Finally, for completeness, I fixed any typos in changelogs and
> release notes. Perhaps you prefer these old files to be kept
> untouched, so that patch is separate.
> 
> Since this is my first patch to e2fsprogs, so please advice
> me if I've made a mistake or two somewhere.

Thanks so much for your fixes!  I've applied them into the e2fsprogs
git repository.

						- Ted
