From: Andrew Morton <akpm@linux-foundation.org>
Subject: data=journal busted
Date: Thu, 15 Feb 2007 20:44:45 -0800
Message-ID: <20070215204445.411d2760.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161705AbXBPEor (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 23:44:47 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1G4ikhB008502
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Feb 2007 20:44:46 -0800
Received: from box (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id l1G4ij95019601
	for <linux-ext4@vger.kernel.org>; Thu, 15 Feb 2007 20:44:46 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I have a report from a google person who just did some basic
power-it-off-during-a-write testing on 2.6.20's ext3.  ordered-data is OK,
but data=journal came back with crap in the file data.

Is anyone doing any formal recovery stress-testing?

I suspect we should resurrect and formalise my old
make-the-disk-stop-accepting-writes-when-a-timer-goes-off thing.  It was
very useful for stress-testing recovery.
