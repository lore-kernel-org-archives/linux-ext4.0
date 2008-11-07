From: Arthur Jones <ajones@riverbed.com>
Subject: Re: [patch 24/51] ext3: wait on all pending commits in ext3_sync_fs
Date: Fri, 7 Nov 2008 06:58:09 -0800
Message-ID: <20081107145809.GC9254@ajones-laptop.nbttech.com>
References: <200811062053.mA6KratV013440@imap1.linux-foundation.org> <20081106214431.GL18939@mit.edu> <20081106142020.b64dee83.akpm@linux-foundation.org> <20081106224202.GA29038@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:50632 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYKGO6K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 09:58:10 -0500
Content-Disposition: inline
In-Reply-To: <20081106224202.GA29038@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, ...

On Thu, Nov 06, 2008 at 02:42:02PM -0800, Theodore Tso wrote:
> [...]
> So that means we'll need two cleanup patches for ext3; one to fix the
> comment, and another to propagate the error code back to the VFS.

A trivial patch for this is in the linux-ext4
mailing list:

http://marc.info/?l=linux-kernel&m=122574905024321&w=2

Arthur

