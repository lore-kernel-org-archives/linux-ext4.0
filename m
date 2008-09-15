From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: patches in queue but missing from series?
Date: Mon, 15 Sep 2008 11:10:55 -0700
Message-ID: <1221502255.6407.3.camel@mingming-laptop>
References: <48CD7DEC.6080008@redhat.com>  <20080914213448.GB8706@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45709 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYIOSL0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 14:11:26 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8FIBBLd031904
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 14:11:11 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8FIBAlN029116
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 12:11:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8G0BA4R006182
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 18:11:10 -0600
In-Reply-To: <20080914213448.GB8706@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-09-14=E6=97=A5=E7=9A=84 17:34 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Sun, Sep 14, 2008 at 02:11:08PM -0700, Eric Sandeen wrote:
> > Looking at what's in the patch queue, but not in the series file:
> >=20
> > ext4-fix-hang-due-to-corrupted-jinode.patch
> > ext4-new-defm-options
> > ext4-online-resize-fix-for-group-descriptor-corruption.patch
> > Fix-EXT_MAX_BLOCK.patch
> > jbd2-dio-kjournal-race-EIO.patch
> > jbd-dio-kjournal-race-EIO.patch
> >=20
> > Some of these are probably intentional (I think Ted has the printk
> > throttling stuff queued up to send) but have any of these simply go=
tten
> > lost somehow?  Or merged upstream (or obsoleted) but not removed?
>=20
> Well, all of the patches in the ext3 directory are non-ext4 patches
> which I sent to akpm on Friday or Saturday; I decided to check them
> into the patch queue to make sure they don't get lost.  I'll remove
> them when they are confirmed in -mm.  These would be:
>=20
> > ext2-printk-throttling
> > ext3_dx_readdir_hash_collision_fix.patch
> > ext3-printk-throttling
> > ext3_truncate_block_allocated_on_a_failed_ext3_write_begin.patch
>=20
> Some of the patches were ones that fixed bugs introduced in other
> patches, and were folded into a parent patch.  This was the case for
> ext4-fix-hang-due-to-corrupted-jinode.patch, which was folded into th=
e
> patch that ultimately became commit 678aaf48 in the mainline Linux
> tree.
>=20
> Ext4-new-defm-options was a patch I was working on that never got
> finished.  It probably shouldn't have gotten checked into the patch
> queue.
>=20
> Girish's Fix-EXT_MAX_BLOCK.patch caused regression failures, so it wa=
s
> dropped from the patch series.  I don't think anyone ever went back t=
o
> figure out why it was causing the ext4 tree to blow up.
>=20
> As far as jbd2-dio-kjournal-race-EIO.patch and
> jbd-dio-kjournal-race-EIO.patch are concerned,
> jbd2-dio-kjournal-race-EIO.patch doesn't even apply any more.  I'm
> guess it was fixed in some other way for jbd2.  It looks the jbd patc=
h
> could apply, but if it's still a valid fix, it should be fed through
> akpm.  Mingming, do you know what the status of these two patches are=
?
>=20

Hi Ted, Eric,

These two patches(jbd and jbd2) could be safely removed from patch
queue, the updated version were pushed to linus from Andrew. I have
removed the staled patches from patch queue

>        		    	     	      	     	- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
