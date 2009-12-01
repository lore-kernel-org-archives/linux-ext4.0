From: Mike Galbraith <gleep@gmx.de>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Tue, 01 Dec 2009 17:47:58 +0100
Message-ID: <1259686078.6229.1.camel@marge.simson.net>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
	 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
	 <1259667765.9614.19.camel@marge.simson.net>
	 <20091201143558.GB12730@quack.suse.cz>
	 <20091201160324.GA25873@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: James Y Knight <foom@fuhm.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	npiggin@suse.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51438 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753786AbZLAQsB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2009 11:48:01 -0500
In-Reply-To: <20091201160324.GA25873@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-12-01 at 17:03 +0100, Jan Kara wrote:

>   The patch below fixes the issue for me...

Ditto.

	-Mike

