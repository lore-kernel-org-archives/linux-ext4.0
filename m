From: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Mon, 3 Nov 2008 16:51:44 +0100
Message-ID: <20081103165144.6514f003@starbug.prg01.itonis.net>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	<20081103134008.GE29102@mit.edu>
	<319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59399 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbYKCQAG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Nov 2008 11:00:06 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kx1qV-00082h-57
	for linux-ext4@vger.kernel.org; Mon, 03 Nov 2008 16:00:03 +0000
Received: from 193.239.0.25 ([193.239.0.25])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 03 Nov 2008 16:00:03 +0000
Received: from makovick by 193.239.0.25 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 03 Nov 2008 16:00:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Nov 2008 16:34:10 +0100
Cryptooctoploid <cryptooctoploid@gmail.com> wrote:

> On Mon, Nov 3, 2008 at 2:40 PM, Theodore Tso <tytso@mit.edu> wrote:
> > On Mon, Nov 03, 2008 at 12:42:11PM +0000, Roc Valles wrote:
> >> Some person already reported this. I'm having the same problem.
> >> http://marc.info/?l=linux-ext4&m=122557056518246&w=2
> >>
> >> rtorrent is a bittorrent client that makes heavy use of mmap
> >> instead of read/write to avoid needless duplication of data. It
> >> has exposed other bugs in the past (mmap bug in 2.6.19).
> >> http://libtorrent.rakshasa.no
> >> Downloading a big torrent (>2GB) with rtorrent triggers it more
> >> times than not. The bigger the torrent, the higher the likeliness
> >> of failure. When the torrent is finished, if a hash check is
> >> forced by pressing control-r on the torrent, some blocks will fail.
> 
> I have set up a debug torrent at:
> http://www.demonoid.com/files/details/1676328/?rel=1225725960
> 
> It contains four identical files that were generated with:
> dd if=/dev/zero of=zero.test0 count=1M
> 
> My upload speed is limited (512 kbit/s), but I hope this may help.

The following testcase was used to trigger the infamous MAP_SHARED
dirty flag bug. Maybe it could be of some help here too:

http://lkml.org/lkml/2006/12/27/180

-- 
Jindrich Makovicka


