From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 10:45:20 -0400
Message-ID: <1207752320.30215.1.camel@zem>
References: <47FBB24D.90807@yahoo.de>  <47FBBB13.7060501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: supersud501 <supersud501@yahoo.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:51902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYDIOpZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 10:45:25 -0400
Received: by py-out-1112.google.com with SMTP id u52so3839763pyb.10
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2008 07:45:23 -0700 (PDT)
In-Reply-To: <47FBBB13.7060501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-04-08 at 13:36 -0500, Eric Sandeen wrote:
> supersud501 wrote:
> > i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
> > 2.6.25-rc8), extents enabled:
> > 
> > e2fsck 1.40.8 (13-Mar-2008)
> > /dev/loop2 has unsupported feature(s): huge_file
> > e2fsck: Get a newer version of e2fsck!
> > 
> > just updated to the git-version of e2fsprogs, same error. i know e2fsck 
> > worked once with the drive (~2 months ago).
> > 
> > what can i do?
> 
> Do you in fact have any very large files on the disk?

I'm just curious - if I know for sure that I don't have any huge files
on my disk, would I be able to do something like use debugfs to simply
clear the flag?

-- 
Calvin Walton <calvin.walton@gmail.com>

