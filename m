From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: discard_zeroes_data questions
Date: Mon, 09 Nov 2015 19:16:28 -0500
Message-ID: <yq1poziwvxf.fsf@sermon.lab.mkp.net>
References: <56412776.6080604@sandeen.net>
	<20151109233845.GA31524@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@sandeen.net>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mellowmood.mkp.net ([104.200.29.94]:53350 "EHLO
	mellowmood.mkp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbKJAWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2015 19:22:47 -0500
In-Reply-To: <20151109233845.GA31524@birch.djwong.org> (Darrick J. Wong's
	message of "Mon, 9 Nov 2015 15:38:45 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Last winter I sent in a patch to invalidate the page cache
Darrick> after a discard:
Darrick> https://marc.info/?l=linux-kernel&m=142249686225748&w=2

Darrick> ...because e2fsck gets confused it discards part of a d_z_d=1
Darrick> device and gets non-zeroed buffers back (from the page cache!)
Darrick> immediately after.

Darrick> But it never went in.  Should I resend it?

Yes, please! I thought this had gone in...

-- 
Martin K. Petersen	Oracle Linux Engineering
