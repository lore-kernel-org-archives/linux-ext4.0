From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: extent counting fun
Date: Mon, 5 Jul 2010 17:46:36 -0600
Message-ID: <AF4CA4E6-4ADE-41E3-843D-02266228E2CB@dilger.ca>
References: <4C323184.8020401@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43149 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0GEXqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jul 2010 19:46:35 -0400
In-Reply-To: <4C323184.8020401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-05, at 13:24, Eric Sandeen wrote:
> [root@host ~]# filefrag -B /mnt/test/file
> /mnt/test/file: 34 extents found
> [root@host ~]# filefrag /mnt/test/file
> /mnt/test/file: 1058 extents found, perfection would be 1 extent
> 
> Hum, is it 34 or 1058? :)

What do the extents look like on disk?  Is this just because it is running on a block-mapped file and is skipping a singleton block periodically for indirect blocks, or is there a bug in the way the extents are being reported?

> Older filefrag counted contiguous metadata as part of a contiguous
> extent... newer filefrag works in fiemap query-only mode by default,
> and just takes what fiemap tells it.  The inconsistency is weird
> though, and led to a Red Hat bug that I'm inclined to NOTABUG... but
> do people think this needs to be made any more consistent?
> 
> Should we hack ext3_fiemap() to include the checks for contiguous
> metadata?  Or was that too shady/clever to start with ...? :)

I wouldn't object to having FIEMAP add a flag for metadata blocks.  I've always thought it would be useful to be able to query/dump metadata blocks (e.g. indirect/index blocks) and the inode itself.

Cheers, Andreas





