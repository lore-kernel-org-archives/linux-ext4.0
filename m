From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Unused block group, but all blocks not free?
Date: Thu, 21 May 2015 20:08:17 -0400
Message-ID: <555E7371.9060207@ubuntu.com>
References: <555BDEF4.1020704@ubuntu.com> <20150520151007.GK2871@thunk.org> <555CA52F.3010109@ubuntu.com> <20150520163148.GA23989@thunk.org> <555D0541.1000804@ubuntu.com> <20150521235940.GB2750@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755960AbbEVALa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 May 2015 20:11:30 -0400
In-Reply-To: <20150521235940.GB2750@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/21/2015 07:59 PM, Theodore Ts'o wrote:
> Ah, so it's pretty self-explanatory.  From the dumpe2fs of the
> image:
> 
> Group 25: (Blocks 819200-851967) csum 0x45a8 [INODE_UNINIT,
> BLOCK_UNINIT, ITABLE_ZEROED] ^^^^^^^^^^^^^ Backup superblock at
> 819200, Group descriptors at 819201-819201 ^^^^^^
> ^^^^^^^^^^^^^ Reserved GDT blocks at 819202-819584 ^^^^^^^^^^^^^ 
> Block bitmap at 524297 (bg #16 + 9) Inode bitmap at 524313 (bg #16
> + 25) Inode table at 528928-529439 (bg #16 + 4640) 32383 free
> blocks, 8192 free inodes, 0 directories, 8192 unused inodes Free
> blocks: 819585-851967 Free inodes: 204801-212992

Interesting... I don't get that information from debugfs.
Specifically it doesn't give the blocks that comprise the group ( but
that is calculated easily enough ), nor list which blocks are reserved
for the GDT.  I'm using 1.42.12, is that a more recent feature?

I had actually just figured out that 25 is where the superblock and
GDT backups are, and therefore, should also contain part of the resize
inode.  It seems that e2defrag adds the blocks owned by reserved
inodes after checking the free count so I'll have to rejigger it to do
that first.

I wonder though, why I didn't see these problems the last time I used
e2defrag, which was probably 2 years ago and was on a filesystem with
a resize inode, and flex_bg and uninitialized bitmaps.  At the time it
seemed that uninitialized bitmaps were not used on groups with blocks
used for these sorts of things.  I guess that must also be a more
recent change.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVXnNxAAoJENRVrw2cjl5RQ9IH/2fO3y4PkV6lUMnyfzfoDxGX
vpv9U1jcKa1KVkbycT7ghB5JF2PugdWA5Y2PB0yrNKpQjhNTcMXx7aa1pAx8JbBc
zzYoOFMyMw6nTPdOz+rLH+VZwI/SqGyy6uLsaIdoQ/FJ5Xcq2mpgRQUt7DQNYXEW
xGdtGWiyxFdVt6SmBOSS0SDfyYnRmv/erqy1BvpZGDL6syVjPfxTcTHaHOY6wKL2
sWcvLO2ynR+ry/c+d6XnWDZb5dz9dZQTZaCj2FVEEsFMDFtQQEu0Eb5/LWGLnQap
TSUfub1fGhRW9ciJBkoC52XKwiMVWKBi59/VpYixIN2s0S+Tiu4+Yn/x1BP3udk=
=Re+Z
-----END PGP SIGNATURE-----
