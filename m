From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
 blocks...
Date: Mon, 20 Apr 2009 13:54:46 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0904201353540.17316@xpc17.ast.cam.ac.uk>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:40358 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZDTMys (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 08:54:48 -0400
In-Reply-To: <20090420124810.GT19186@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Apr 2009, Theodore Tso wrote:

> That's that's useful data.  I wish we could make it fail more quickly
> on a smaller rsync, but the fact that you didn't need to reboot is
> definitely useful information.
>
> And this is a fresh rsync so no files were being deleted, rsync should
> have just been writing new files to .filename.XXXXX and then renaming
> the filename to filename.XXXXX when it is done, right?

That's what I'd guess. It was onto a clean filesystem, so there shouldn't 
be any deletions.

> OK, let me think about this a little.  I think we can create a patch
> which checks for writes to the block group descriptors and dumps a
> stack trace.  That would allow us catch the failing code in question
> in the act, and maybe figure out what is going on.

Ok.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053
