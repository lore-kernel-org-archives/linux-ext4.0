From: Theodore Tso <tytso@mit.edu>
Subject: Re: tune2fs -I 256 -- kind of slow?
Date: Tue, 14 Oct 2008 07:17:59 -0400
Message-ID: <20081014111759.GA8674@mit.edu>
References: <87d4i3lr3u.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Collins <paul@burly.ondioline.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46479 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755261AbYJNLSE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 07:18:04 -0400
Content-Disposition: inline
In-Reply-To: <87d4i3lr3u.fsf@burly.wgtn.ondioline.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2008 at 05:48:05PM +1300, Paul Collins wrote:
> I just ran "tune2fs -I 256 /dev/sda3" and it took about an hour and
> forty minutes.  The filesystem is about 33GiB, 3/4 full, ~85,000 inodes.
> The machine is a 2.13GHz Core 2 Duo, SATA disk.  It seemed to be
> CPU-bound, soaking up a core for the whole run.  Does this sound right?
> 
> Running e2fsprogs 1.41.3-1 from Debian unstable.

You're not the first person to have reported this.  I don't think
anyone has had a chance to look at it, but it's something we clearly
need to pay attention to --- 33 GB isn't that big of a filesystem, as
filesystems go, and an hour and a half and being CPU bound is not a
good thing.

							- Ted
