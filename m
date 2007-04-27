From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Fri, 27 Apr 2007 14:38:21 -0600
Message-ID: <20070427203821.GJ5967@schatzie.adilger.int>
References: <4631FD7F.9030008@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46869 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221AbXD0UiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 16:38:23 -0400
Content-Disposition: inline
In-Reply-To: <4631FD7F.9030008@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 27, 2007  15:41 +0200, Valerie Clement wrote:
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
> 
> 
> And with a more fragmented 100-GB file:
> 
>                  |     ext3       ext4 + extents       xfs
> ------------------------------------------------------------
>  nb of fragments |   20297           19841            234
>  elapsed time    | 2m18.914s        0m27.429s      0m0.892s
>                  |
>  blks read       |  225624           25432            592
>  blks written    |   52120           50664            872
> ------------------------------------------------------------
> 
> 
> More details on our web site:
> http://www.bullopensource.org/ext4/20070404/FileDeletion.html

Ah, one thing that is only mentioned in the URL is that the "IO count" is
in units of 512-byte sectors.  In the case of XFS doing logical journaling
this avoids a huge amount of double writes to the journal and then to the
filesystem.  I still think ext4 could do better than it currently does.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
