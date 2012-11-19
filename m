From: "George Spelvin" <linux@horizon.com>
Subject: Re: Issue with bad file system
Date: 19 Nov 2012 14:15:05 -0500
Message-ID: <20121119191505.24680.qmail@science.horizon.com>
References: <20121119184107.GA29487@thunk.org>
Cc: dreusser@gmail.com, linux-ext4@vger.kernel.org, linux@horizon.com
To: sandeen@redhat.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:59151 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753990Ab2KSTPG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 14:15:06 -0500
In-Reply-To: <20121119184107.GA29487@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> (In particular, I want to make sure that random journal corruptions are
> handled correctly when the metadata checksum feature is enabled ---
> before we start having more enthusiastic users try out bleeding edge
> features on production file systems....)

Oh, more enthusiastic users are *already* trying out metadata_csum
on production file systems.  And finding lots of bugs doing so!

My latest is a file system where e2fsck can find the problem, but
can't fix it.
