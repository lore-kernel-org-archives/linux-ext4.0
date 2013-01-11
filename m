From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: new block group bitmaps not being initialized after resize!?
Date: Thu, 10 Jan 2013 19:07:15 -0600
Message-ID: <50EF65C3.8010406@redhat.com>
References: <20130111000711.GA2490@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3AKBHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2013 20:07:17 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0B17Hns006449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2013 20:07:17 -0500
In-Reply-To: <20130111000711.GA2490@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/10/13 6:07 PM, Carlos Maiolino wrote:
> Hi guys,
> 
> I'm working on a Fedora bugzilla (https://bugzilla.redhat.com/show_bug.cgi?id=852833)
> together with Eric and we found that the problem described on the bugzilla
> happens when the commit 93f9052643 is not applied, which is the case of the
> Fedora 16 kernel being discussed there.

Also, to be clear, this is with older e2fsprogs which was using the old resize
interface.  Not sure what the behavior is w/ newer e2fsprogs, but we don't
see the corruption.

Note, we see the corruption on these older kernels even when resizing from
say 100G to 120G.  It appears fixed upstream, but so much has changed,
we need to be sure the older interface doesn't have bugs lurking, I think.

> Although we already found the solution to the problem in the commit above,
> looking through the commit have raised some questions regarding to the bitmap of
> the newer block groups added to the FS after it is extended.
> 
> The newer block groups do not have flags ITABLE_ZEROED and INODE_UNINIT set,
> even when 'lazy_itable_init' is enabled.

In particular, we see things like this in the last pre-resize group:

Group 799: (Blocks 26181632-26214399) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xafe7, unused inodes 1936
  Block bitmap at 25165855 (bg #768 + 31), Inode bitmap at 25166111 (bg #768 + 287)
  Inode table at 25170087-25170207 (bg #768 + 4263)
  32768 free blocks, 1936 free inodes, 0 directories, 1936 unused inodes
  Free blocks: 26181632-26214399
  Free inodes: 1546865-1548800

and this in the newly-added groups:

Group 800: (Blocks 26214400-26247167)
  Checksum 0xddc4, unused inodes 0
  Block bitmap at 26236224 (+21824), Inode bitmap at 26236225 (+21825)
  Inode table at 26214400-26214520
  32645 free blocks, 1936 free inodes, 0 directories
  Free blocks: 26214521-26236223, 26236226-26247167
  Free inodes: 1548801-1550736

so it says 0 unused inodes, but also 1936 free inodes (?), and
no UNINIT or ZEROED flags set.  e2fsck finds stale data in the inode table,
and goes nuts.

> Without this commit, inode stale data might be exposed and also makes fsck
> complain about all inodes of the newer block groups.

*nod* :)
 
so 93f9052643 seems to have accidentally fixed this, by setting
the unused counter to EXT4_INODES_PER_GROUP(), but it feels like
we've missed properly setting up this block group.

To be honest, though, sometimes I get lost in the sea of flags.

> The question is, are these flags expected to not be found on these newer block
> groups or they should be set?

*nod* :)

-Eric

> The lack of these flags on newer block groups is an expected behaviour or is
> something that should be fixed?
> 
> FWIW, in the old ext4_group_add(), we added EXT4_BG_INODE_ZEROED flag to the
> bg_flags, also, I did some tests here and the lack of these flags look to not be
> affecting filesystem integrity, i.e. new inodes can be properly allocated, which
> sounds that these uninitialized inodes/bitmaps are set to be initialized as soon
> as a first inode is allocated on these new BGs.
> 
> 
> Anything else I'm missing Eric?
> 
> Cheers,
> 

