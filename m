From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 13:26:56 -0200
Message-ID: <20081202152656.GH1668@khazad-dum.debian.net>
References: <200811291418.24672.andres@anarazel.de> <200812011335.00366.andres@anarazel.de> <20081201194204.GZ3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andres Freund <andres@anarazel.de>, Theodore Tso <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51982 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbYLBP1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 10:27:00 -0500
Content-Disposition: inline
In-Reply-To: <20081201194204.GZ3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 01 Dec 2008, Andreas Dilger wrote:
> - do the applications writing to this file have any unusual IO pattern
>   (e.g. mmap IO, lots of write+truncate+write on the same file, etc)

Vuze does a massive ammount of sparse writes.  It can also be configured to
pre-allocate space (either by creating an empty non-sparse file, or by
telling the kernel that the file is expected to grow to size foo and to
please pre-allocate that in the filesystem.  I don't recall how this is
done).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
