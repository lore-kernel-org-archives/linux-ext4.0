From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/1][RFC]  prepare_write positive return value V(2)
Date: Sun, 25 Feb 2007 02:39:54 -0800
Message-ID: <20070225023954.f400cb4a.akpm@linux-foundation.org>
References: <87y7n3909x.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59448 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBYKj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Feb 2007 05:39:59 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1PAdvhB011503
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 25 Feb 2007 02:39:58 -0800
Received: from sony (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id l1PAdtpI027522
	for <linux-ext4@vger.kernel.org>; Sun, 25 Feb 2007 02:39:56 -0800
In-Reply-To: <87y7n3909x.fsf@sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Could someone please review/test/comment upon this work?

I don't think ext[34] is an area where I need to do everything myself ;)

Thanks.
