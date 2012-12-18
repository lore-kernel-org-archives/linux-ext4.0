From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Tune2fs metadata_csum
Date: Mon, 17 Dec 2012 19:19:23 -0800
Message-ID: <20121218031923.GA10770@blackbox.djwong.org>
References: <1355717041.99349.YahooMailNeo@web164606.mail.gq1.yahoo.com>
 <20121217143703.GB31563@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Lind <anderslindgaard@yahoo.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2LRDT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2012 22:19:27 -0500
Content-Disposition: inline
In-Reply-To: <20121217143703.GB31563@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 17, 2012 at 09:37:03AM -0500, Theodore Ts'o wrote:
> On Sun, Dec 16, 2012 at 08:04:01PM -0800, Anders Lind wrote:
> > 
> > I tired to use tune2fs metadata_csum feature on my ext4 filesystem.
> > I got message like:
> > ~$ sudo tune2fs -O metadata_csum /dev/sda5
> > tune2fs 1.42 (29-Nov-2011)
> > Setting filesystem feature 'metadata_csum' not supported.
> > 
> > Is this tool supposed been used on unmounted device or it could be mounted?
> 
> TYhe metadata_csum feature is in the e2fsprogs "master" branch in the
> e2fsprogs git tree.  The feature is not part of an official e2fsprogs
> release yet.  One of the things that I want to really check very
> carefully before I release e2fsprogs 1.43 is that e2fsck sanely
> recovers from checksum failures while it tries replaying the journal.

Oh, right, I /was/ planning (last year) to go dig through recovery.c, wasn't I?
And I think I was going to change the replay/checksum behavior so that checksum
errors would result in that block being skipped, without aborting the entire
replay.

(Or something like that?  My memory is hazy.)

Well, thanks for the reminder.

--D
> 
> Essentially, metadata_csum is supposed to provide better recovery from
> device failures (it doesn't really provide any kind of performance
> advantage), and I want to be 100% sure that it is **always** better
> when hardware-induced corruption happens before we release it.
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
