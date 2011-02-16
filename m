From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsprogs: turn off enforced fsck intervals by
 default
Date: Wed, 16 Feb 2011 17:55:16 -0500
Message-ID: <20110216225516.GE26780@thunk.org>
References: <4D5C1380.2020602@redhat.com>
 <4D5C1409.1030203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55990 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab1BPWzX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 17:55:23 -0500
Content-Disposition: inline
In-Reply-To: <4D5C1409.1030203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 16, 2011 at 12:14:33PM -0600, Eric Sandeen wrote:
> The forced fsck often comes at unexpected and inopportune moments,
> and even enterprise customers are often caught by surprise when 
> this happens.  Because a filesystem with an error condition will 
> be marked as requiring fsck anyway, I submit that the time-based 
> and mount-based checks are not particularly useful, and that 
> administrators can schedule fscks on their own time, or tune2fs 
> the enforced intervals if they so choose.  Patch #1 disables the 
> intervals by default, and I've added a new mkfs option (-C) to 
> turn on the old behavior of random, unexpected, time-consuming
> fscks at boot time.  ;)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

How about just making it be an /etc/mke2fs.conf profile.  Just use
something like this:

    get_bool_from_profile(fs_types, "enable_periodic_fsck", 0)

... and I don't think we need to have a new command-line option.
People who want old behaviour can do

[defaults]
    enable_period_fsck = true

						- Ted
