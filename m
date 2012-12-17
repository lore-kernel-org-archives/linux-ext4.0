From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Tune2fs metadata_csum
Date: Mon, 17 Dec 2012 09:37:03 -0500
Message-ID: <20121217143703.GB31563@thunk.org>
References: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Anders Lind <anderslindgaard@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38866 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2LQOhG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 09:37:06 -0500
Content-Disposition: inline
In-Reply-To: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 16, 2012 at 08:04:01PM -0800, Anders Lind wrote:
> 
> I tired to use tune2fs metadata_csum feature on my ext4 filesystem.
> I got message like:
> ~$ sudo tune2fs -O metadata_csum /dev/sda5
> tune2fs 1.42 (29-Nov-2011)
> Setting filesystem feature 'metadata_csum' not supported.
> 
> Is this tool supposed been used on unmounted device or it could be mounted?

TYhe metadata_csum feature is in the e2fsprogs "master" branch in the
e2fsprogs git tree.  The feature is not part of an official e2fsprogs
release yet.  One of the things that I want to really check very
carefully before I release e2fsprogs 1.43 is that e2fsck sanely
recovers from checksum failures while it tries replaying the journal.

Essentially, metadata_csum is supposed to provide better recovery from
device failures (it doesn't really provide any kind of performance
advantage), and I want to be 100% sure that it is **always** better
when hardware-induced corruption happens before we release it.

Regards,

						- Ted
