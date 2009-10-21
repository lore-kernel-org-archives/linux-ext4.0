From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: Always fix last mount/write/check time with -p
Date: Wed, 21 Oct 2009 18:20:58 -0400
Message-ID: <20091021222058.GD20619@mit.edu>
References: <E1MxMjT-0003XH-Mn@zelda.netsplit.com> <20091017010330.GA8081@mit.edu> <4AD9E15D.2060400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott James Remnant <scott@ubuntu.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35198 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZJUWVA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Oct 2009 18:21:00 -0400
Content-Disposition: inline
In-Reply-To: <4AD9E15D.2060400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 17, 2009 at 10:23:09AM -0500, Eric Sandeen wrote:
>> From ba5131f6d48eded504e84c2a8ffc8131df8a512e Mon Sep 17 00:00:00 2001
>> From: Theodore Ts'o <tytso@mit.edu>
>> Date: Fri, 16 Oct 2009 20:46:45 -0400
>> Subject: [PATCH] e2fsck: Accept superblock times to be fudged by up to 24 hours by default
>
> could you please push this out to the kernel.org repo?

Done, sorry for the delay.

							- Ted
