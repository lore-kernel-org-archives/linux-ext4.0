From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
Date: Fri, 14 Jun 2013 09:39:39 -0400
Message-ID: <20130614133710.GA6250@localhost>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-16-git-send-email-lczerner@redhat.com>
 <20130614030154.GA18731@thunk.org>
 <alpine.LFD.2.00.1306141216070.2327@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57977 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3FNNjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Jun 2013 09:39:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306141216070.2327@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 14, 2013 at 12:16:53PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > It bisects down to this patch, and if I take the dev branch, and
> > revert patches #15 through #19 in this series, the problem goes awa=
y.

Correction...  reverting patches #15 through #19 (which is what I did i=
n
the dev-with-revert branch found on ext4.git) causes the problem to go
away in the nojournal case, but it causes a huge number of other
problems.  Some of the reverts weren't clean, so it's possible I
screwed up one of the reverts.  It's also possible that only applying
part of this series leaves the tree in an unstable state.

I'd much rather figure out how to fix the problem on the dev branch,
so thank you for looking into this!

						- Ted

BEGIN TEST: Ext4 4k block Thu Jun 13 23:25:45 EDT 2013
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/231=
 generic/255 generic/263 shared/218
END TEST: Ext4 4k block Fri Jun 14 00:29:17 EDT 2013

BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri =
Jun 14 00:29:22 EDT 2013
    +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent =
(see /root/xfstests/results/generic/269.full)
generic/270 69s ...     [01:34:24][ 8102.435986] EXT4-fs error (device =
vdc): htree_dirblock_to_tree:920: inode #25735: block 99331: comm quota=
check: bad entry in directory: rec_len % 4 !=3D 0 -\
 offset=3D0(0), inode=3D3739147998, rec_len=3D57054, name_len=3D222
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/231=
 generic/263 generic/269 generic/270 generic/285 generic/300 shared/218
END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Ju=
n 14 01:49:59 EDT 2013

BEGIN TEST: Ext4 4k block w/ no journal Fri Jun 14 01:50:00 EDT 2013
    +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent =
(see /root/xfstests/results/generic/269.full)
generic/270 69s ...     [02:20:21][10531.911437] EXT4-fs error (device =
vdc): htree_dirblock_to_tree:920: inode #9894: block 6526: comm quotach=
eck: bad entry in directory: rec_len is smaller t\
han minimal - offset=3D0(0), inode=3D0, rec_len=3D0, name_len=3D0
[10532.535861] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9692: block 6534: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
[10534.266775] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9906: block 6530: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
[10534.697885] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #24673: block 6531: comm quotacheck: bad entry in directory: rec_=
len % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec\
_len=3D15934, name_len=3D62
[10535.157126] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9898: block 6532: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
[10536.395838] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9905: block 6529: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
[10537.029470] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9899: block 6533: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
[10537.259601] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: =
inode #9929: block 6527: comm quotacheck: bad entry in directory: rec_l=
en % 4 !=3D 0 - offset=3D0(0), inode=3D1044266558, rec_\
len=3D15934, name_len=3D62
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/231=
 generic/255 generic/263 generic/269 generic/270 shared/218 shared/298
END TEST: Ext4 4k block w/ no journal Fri Jun 14 02:32:14 EDT 2013

BEGIN TEST: Ext4 1k block Fri Jun 14 02:32:18 EDT 2013
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/231=
 generic/255 generic/263 generic/285 shared/218
END TEST: Ext4 1k block Fri Jun 14 04:00:17 EDT 2013

BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Jun 14 04:00:=
20 EDT 2013
    +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent =
(see /root/xfstests/results/generic/269.full)
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/223=
 generic/231 generic/255 generic/263 generic/269 shared/218
END TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Jun 14 05:16:10=
 EDT 2013

BEGIN TEST: Ext4 4k block w/metadata_csum Fri Jun 14 05:16:12 EDT 2013
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/231=
 generic/255 generic/263 shared/218
END TEST: Ext4 4k block w/metadata_csum Fri Jun 14 06:16:31 EDT 2013

BEGIN TEST: Ext4 4k block w/dioread_nolock Fri Jun 14 06:16:31 EDT 2013
_check_generic_filesystem: filesystem on /dev/vdb is inconsistent (see =
/root/xfstests/results/generic/013.full)
=46ailures: generic/013
END TEST: Ext4 4k block w/dioread_nolock Fri Jun 14 06:21:37 EDT 2013

BEGIN TEST: Ext4 4k block w/data=3Djournal Fri Jun 14 06:21:41 EDT 2013
    +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent =
(see /root/xfstests/results/generic/269.full)
    +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent =
(see /root/xfstests/results/generic/300.full)
[29242.456266] WARNING: at /usr/local/google/home/tytso/linux/ext4/fs/b=
uffer.c:1120 mark_buffer_dirty+0x54/0x1ff()
=46ailures: generic/075 generic/091 generic/112 generic/127 generic/223=
 generic/231 generic/255 generic/263 generic/269 generic/270 generic/30=
0 shared/218
END TEST: Ext4 4k block w/data=3Djournal Fri Jun 14 07:33:10 EDT 2013

BEGIN TEST: Ext4 4k block w/bigalloc Fri Jun 14 07:33:16 EDT 2013
[33544.485801] WARNING: at /usr/local/google/home/tytso/linux/ext4/fs/q=
uota/dquot.c:1090 dquot_claim_space_nodirty+0xf1/0x1e3()
=46ailures: generic/204 generic/219 generic/233 generic/235 generic/273=
 generic/275 generic/300 shared/218
END TEST: Ext4 4k block w/bigalloc Fri Jun 14 08:56:56 EDT 2013

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
