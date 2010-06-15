From: Paul Eggert <eggert@CS.UCLA.EDU>
Subject: Re: bug#6131: [PATCH]: fiemap support for efficient sparse file copy
Date: Tue, 15 Jun 2010 14:11:01 -0700
Message-ID: <4C17EC65.6040406@cs.ucla.edu>
References: <4BE41FFF.4020809@oracle.com>	<871vdho68j.fsf@meyering.net>	<4BEC0BCC.3080906@oracle.com>	<87k4qyl6lw.fsf@meyering.net>	<4BF683CC.3060407@oracle.com>	<4BF6ABE7.3020600@oracle.com>	<877hmpeivx.fsf@meyering.net>	<4BFF763A.9010205@oracle.com>	<8763286kni.fsf@meyering.net>	<4C0275FA.1030901@oracle.com>	<874ohpywri.fsf@meyering.net>	<87y6exuc5i.fsf@meyering.net>	<874ohdu5b8.fsf@meyering.net>	<87eighs1t9.fsf@meyering.net>	<4C0FA93C.6020205@oracle.com>	<87iq5sp7eg.fsf@meyering.net> <4C108CB9.8010805@oracle.com> <4C11798B.6090500@cs.ucla.edu> <4C1183FD.9010502@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "jeff.liu" <jeff.liu@oracle.com>, Jim Meyering <jim@meyering.net>,
	Tao Ma <tao.ma@oracle.com>, bug-coreutils@gnu.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from Kiwi.CS.UCLA.EDU ([131.179.128.19]:51967 "EHLO kiwi.cs.ucla.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466Ab0FOVQ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 17:16:56 -0400
In-Reply-To: <4C1183FD.9010502@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sunil Mushran wrote:

> SEEK_HOLE/DATA also have the same problem with active files.

Yes, that's true if 'cp' is copying a file while someone else is writing to it.
But the case we're worried about is when 'cp' starts copying a file immediately
after someone else has finished writing to it but data has not been sent to
disk; in that case SEEK_HOLE/DATA should work just as well as the fiemap ioctl.

