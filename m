From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: more respect for quota config option
Date: Mon, 14 Oct 2013 09:03:50 -0400
Message-ID: <20131014130350.GH9609@thunk.org>
References: <52420014.8090901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bert DeKnuydt <Bert.Deknuydt@esat.kuleuven.be>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45881 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab3JNNDw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Oct 2013 09:03:52 -0400
Content-Disposition: inline
In-Reply-To: <52420014.8090901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 24, 2013 at 04:11:48PM -0500, Eric Sandeen wrote:
> Commit 44a2cca3 disabled tune2fs -O quota when the build
> didn't have --enable-quota at configure time, but that
> wasn't quite enough.
> 
> We need to exclude the "-Q" option as well from tune2fs
> when --enable-quota isn't specified at configure time.
> 
> Otherwise, tune2fs -Q can set the quota feature, but no other
> utility will touch the filesystem due to the unknown flag,
> if buitl w/o --enable-quota.
> 
> So put everything related to "-Q" under #ifdef CONFIG_QUOTA;
> usage output (was missing before) and option parsing.
> 
> Addresses-Red-Hat-Bugzilla: #1010709
> Reported-by: Bert DeKnuydt <Bert.Deknuydt@esat.kuleuven.be>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to maint branch, thanks.

					- Ted
