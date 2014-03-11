From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: A couple of ext4 crashes with inlinedata/bigalloc
Date: Mon, 10 Mar 2014 23:25:50 -0700
Message-ID: <20140311062550.GL9875@birch.djwong.org>
References: <20140311030604.GK9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23059 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaCKG0A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20140311030604.GK9875@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 08:06:04PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> A couple of errors to complain about before I send out the e2fsprogs patchbomb.
> :)
> 
> Zheng: I've been running the metadata checksum test with inline_data set.
> flat_dir_test is a stress test which copies /usr/share/doc into a filesystem
> and then "enlarges" the directories by recursively renaming "$foo" to
> "$foo.longer", with the results below.  e2fsck complained that the directories
> involved (4156, 4251) have multiple links to the subdir inode.  I'm not sure
> what this is all about; the only (circumstantial) evidence I have is that it
> goes away if I don't turn on inline_data.

Oh yeah -- I also noticed that when resize2fs shrinks an inline_data fs, it
doesn't rewrite the inline directory blocks with new inode numbers, which
corrupts the filesystem.  Well, that's another couple of patches for the
patchbomb.... :/

--D
