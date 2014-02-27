From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: A tool that allows changing inode table sizes
Date: Thu, 27 Feb 2014 11:35:28 -0500
Message-ID: <530F6950.2020702@ubuntu.com>
References: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: vitalif@yourcmc.ru, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46848 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaB0Qfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Feb 2014 11:35:30 -0500
In-Reply-To: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Wow!  That is quite a project, and this patch manager sounds very
nice.  Good work!

On 1/15/2014 8:28 AM, vitalif@yourcmc.ru wrote:
> Hi all!
> 
> As I understand it was a well-known fact that ext2/3/4 does not
> allow changing inode table size without recreating the filesystem.
> And I didn't have any experience in linux filesystem internals
> until recently, when I've discovered that inode tables take 45 GB
> on one of my hard drives (3 TB in size) :-):-) that hard drive is,
> of course, full of movies, not 16Kb files, so the inode tables are
> almost 100% unused.
> 
> So, I've thought it would be good if it it would possible to
> change inode table sizes. So I've written a tool that in fact
> allows to do it, and I want to present it to the community! :)
> 
> Anyone is welcome to test it of course if it's of any interest for
> you - the source is here 
> http://svn.yourcmc.ru/viewvc.py/vitalif/trunk/ext4-realloc-inodes/ 
> ('download tarball') (maybe it would be better to move it into a 
> separate git repo, of course)
> 
> I didn't test it on a real hard drive yet :-D, only on small fs
> images with different settings (block, block group, flex_bg size,
> ext2/3/4, bigalloc and etc). There are even some auto-tests (ran by
> 'make test'). The tools works without problem on all small test
> images that I've created, though I didn't try to run it on bigger
> filesystems (of course I'll do it in the nearest future).
> 
> As this is a highly destructive process that involves overwriting
> ALL inode numbers in ALL directory entries across the whole
> filesystem, I've also implemented a simple method of safely
> applying/rolling back changes. First I've tried to use
> undo_io_manager, but it appears to be very slow because of frequent
> commits, which are of course needed for it to be safe. My method is
> called patch_io_manager and does a different thing - it does not
> overwrite the initial FS image, but writes all modified blocks into
> a separate sparse file + writes a bitmap of modified blocks in the
> end when it finishes. I.e. the initial filesystem stays
> unmodified.
> 
> Then, using e2patch utility (it's in the same repository), you can
> a) backup the blocks that will be modified into another patch file
> (e2patch backup <fs> <patch> <backup>) and b) apply the patch to
> real filesystem. If the applying process gets interrupted (for
> example by the power outage) it can be restarted from the beginning
> because it does nothing except just overwriting some blocks. And if
> the FS changes appear to be bad at all, you can restore the backup
> in a same way. So the process should be safe at least to some
> extent.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTD2lQAAoJEI5FoCIzSKrwrigH/jNowCyOlpQSzJZhRr6GH6GS
2R9o5Y5xyAD45EzuLHGNQVJ0kWo+nK88SDhn1cO4ZmHrpwEEZXo1g4EaPXglTXaw
LhV3/Nexw83dB6JbfIff7ko4b6IgIBtugRPuvSuWPxpGg8+3QuXKE89DzfPbC0SI
46KiT94QsJOVdtWYlZ91klJsswMW80VOVUm+EJXz+A+E1/HnSEe/ytwsV7nIaVEq
Xq/hiQ6sYvYEpOmLXLOL10VnHlvzzEqgFG2Q7AttcyUzUw8igkpXqBu6wO265uO8
ENgWJrjMKaSKpE4JqZiaXJvuke7hR7luW28mY5qydlLnvcW2IH/cN6eGgZGUhWc=
=nyEa
-----END PGP SIGNATURE-----
