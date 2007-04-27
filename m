From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Large File Deletion Comparison (ext3, ext4, XFS)
Date: Sat, 28 Apr 2007 00:48:30 +0400
Message-ID: <4632619E.4080208@clusterfs.com>
References: <4631FD7F.9030008@bull.net> <20070427203821.GJ5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:63743 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbXD0Us5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 16:48:57 -0400
In-Reply-To: <20070427203821.GJ5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> Ah, one thing that is only mentioned in the URL is that the "IO count" is
> in units of 512-byte sectors.  In the case of XFS doing logical journaling
> this avoids a huge amount of double writes to the journal and then to the
> filesystem.  I still think ext4 could do better than it currently does.

I thought about this in context of huge directories when working set of blocks
is very large and it doesn't fit journal causing frequent commits. two ideas
I was thinking of are: 1) journal "change" where possible 2) compress whole
transaction to be written in the journal

thanks, Alex
