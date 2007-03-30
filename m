From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: Ext4 benchmarks
Date: Fri, 30 Mar 2007 10:43:09 +0200
Message-ID: <20070330084309.GA9249@lombardij>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net> <460A79C2.6030406@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52688 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbXC3InP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2007 04:43:15 -0400
In-Reply-To: <460A79C2.6030406@us.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 28, 2007 at 09:20:50AM -0500, Jose R. Santos wrote:
> While it may be to late for the purposes of your OLS paper, one thing 
> that doesn't seem to be getting much attention is the performance of a 
> file system while doing many meta-data operations or throughput testing 
> during heavy journal log activity.

Back in 2005, Alex sent a patch to monitor journal activity through procfs:
http://marc.info/?l=linux-ext4&m=113538565128617&w=2

We have been using this patch for more than 1 year and it is very useful
for investigating performance issues.
Does anybody know why this patch hasn't found its way into the mainline?
Maybe it could be merged in jbd2?

Johann
