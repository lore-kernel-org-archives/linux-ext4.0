From: Paul Eggert <eggert@CS.UCLA.EDU>
Subject: Re: bug#6131: [PATCH]: fiemap support for efficient sparse file copy
Date: Tue, 15 Jun 2010 14:09:22 -0700
Message-ID: <4C17EC02.7040505@cs.ucla.edu>
References: <4BE41FFF.4020809@oracle.com>	<871vdho68j.fsf@meyering.net>	<4BEC0BCC.3080906@oracle.com>	<87k4qyl6lw.fsf@meyering.net>	<4BF683CC.3060407@oracle.com>	<4BF6ABE7.3020600@oracle.com>	<877hmpeivx.fsf@meyering.net>	<4BFF763A.9010205@oracle.com>	<8763286kni.fsf@meyering.net>	<4C0275FA.1030901@oracle.com>	<874ohpywri.fsf@meyering.net>	<87y6exuc5i.fsf@meyering.net>	<874ohdu5b8.fsf@meyering.net>	<87eighs1t9.fsf@meyering.net>	<4C0FA93C.6020205@oracle.com>	<87iq5sp7eg.fsf@meyering.net>	<4C108CB9.8010805@oracle.com> <4C11798B.6090500@cs.ucla.edu> <4C1183FD.9010502@oracle.com> <4C11F451.8040304@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Jim Meyering <jim@meyering.net>, bug-coreutils@gnu.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tao Ma <tao.ma@oracle.com>
To: "jeff.liu" <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from Kiwi.CS.UCLA.EDU ([131.179.128.19]:51967 "EHLO kiwi.cs.ucla.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab0FOVQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 17:16:57 -0400
In-Reply-To: <4C11F451.8040304@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/11/2010 01:31 AM, jeff.liu wrote:

> +      fiemap->fm_flags = FIEMAP_FLAG_SYNC;

If I'm reading the Linux source code correctly,
this forces all the dirty blocks in the input file to disk, and
forces the kernel to wait until all those blocks actually hit the disk.
We don't need that; there shouldn't be a need to force any
blocks to hit the disk.  All that 'cp' needs to know is: please tell me
the next block which might contain nonzero data.  Is there some way
that we can get that information without forcing the input file's
blocks to disk?
