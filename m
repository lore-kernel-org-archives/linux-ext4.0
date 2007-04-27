From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Fri, 27 Apr 2007 22:51:26 +0400
Message-ID: <4632462E.7090109@clusterfs.com>
References: <4631FD7F.9030008@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:63232 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbXD0Svk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 14:51:40 -0400
In-Reply-To: <4631FD7F.9030008@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Clement wrote:
> As asked by Alex, I included in the test results the file fragmentation 
> level and the number of I/Os done during the file deletion.
> 
> Here are the results obtained with a not very fragmented 100-GB file:
> 
>                  |     ext3       ext4 + extents      xfs
> ------------------------------------------------------------
>  nb of fragments |     796             798             15
>  elapsed time    |  2m0.306s        0m11.127s       0m0.553s
>                  |
>  blks read       |  206600            6416            352
>  blks written    |   13592           13064            104
> ------------------------------------------------------------


hmm. if I did math right, then, in theory, 100GB file could be
placed using ~850 extents: 100 * 1024 / 120, where 120 is amount
of data one can allocate in regular group. 850 extents would
require 3 leaf blocks (340 extents/block) + 1 index block. we'd
need to read these 4 blocks + all 850 involved bitmaps + some
blocks of group descriptors. so, probably we need to tune balloc.
then we'd improve remove time by factor six (6400 blocks to read
vs. ~900-1000 blocks to read) ?

thanks, Alex
