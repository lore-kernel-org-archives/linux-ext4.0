From: Theodore Tso <tytso@mit.edu>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Mon, 3 Nov 2008 08:40:08 -0500
Message-ID: <20081103134008.GE29102@mit.edu>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cryptooctoploid <cryptooctoploid@gmail.com>,
	linux-ext4@vger.kernel.org
To: Roc Valles <vallesroc@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58873 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbYKCNkK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 08:40:10 -0500
Content-Disposition: inline
In-Reply-To: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 12:42:11PM +0000, Roc Valles wrote:
> Some person already reported this. I'm having the same problem.
> http://marc.info/?l=linux-ext4&m=122557056518246&w=2
>
> rtorrent is a bittorrent client that makes heavy use of mmap instead
> of read/write to avoid needless duplication of data. It has exposed
> other bugs in the past (mmap bug in 2.6.19).
> http://libtorrent.rakshasa.no
> Downloading a big torrent (>2GB) with rtorrent triggers it more times
> than not. The bigger the torrent, the higher the likeliness of
> failure. When the torrent is finished, if a hash check is forced by
> pressing control-r on the torrent, some blocks will fail.

Can both of you send the output of "dumpe2fs -h /dev/<disk device>" of
the filesystem in question?  The thing which I'm most interested in is
whether the extents feature was enabled or not.  (i.e., was this a
freshly made ext4 filesystem, or a ext3 filesystem mounted under ext4,
and with which features eanbled?)

Thanks,

						- Ted
