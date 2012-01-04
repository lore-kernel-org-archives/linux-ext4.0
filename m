From: Dave Chinner <david@fromorbit.com>
Subject: Re: A stackable filesystem to trace low level filesystem operations
Date: Wed, 4 Jan 2012 11:03:14 +1100
Message-ID: <20120104000314.GV23662@dastard>
References: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sushil Mantri <sushilmantri@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24494 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab2ADADR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 19:03:17 -0500
Content-Disposition: inline
In-Reply-To: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 03, 2012 at 04:20:21PM -0500, Sushil Mantri wrote:
> Hi All,
> 
> Sorry but this isn't a ext4 specific question but a general filesystem question.
> 
> I am looking for a way to track filesystem level operation like
> operation(read/write), filename, offset, size of read/write, pid of
> the requesting process. The goal of my project is to collect such
> traces and understand access usage of directories and more. I would
> like to filter other operation like open,close, etc and requests to
> procfs, etc. There was a stackable file system earlier called Tracefs.
> It isn't supported anymore though. The original paper can be found
> here: filesystems.org/docs/tracefs-fast04/tracefs.ps

Add your own trace points to the VFS and extract and filter them
with trace-cmd.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
