From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 benchmarks
Date: Fri, 30 Mar 2007 12:50:20 -0600
Message-ID: <20070330185019.GW5967@schatzie.adilger.int>
References: <45FFFBAA.6080404@bull.net> <4600A1BD.80700@us.ibm.com> <460A3010.6080201@bull.net> <460A79C2.6030406@us.ibm.com> <20070330084309.GA9249@lombardij>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>,
	linux-ext4@vger.kernel.org
To: Johann Lombardi <johann.lombardi@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44518 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbXC3SuY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2007 14:50:24 -0400
Content-Disposition: inline
In-Reply-To: <20070330084309.GA9249@lombardij>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 30, 2007  10:43 +0200, Johann Lombardi wrote:
> On Wed, Mar 28, 2007 at 09:20:50AM -0500, Jose R. Santos wrote:
> > While it may be to late for the purposes of your OLS paper, one thing 
> > that doesn't seem to be getting much attention is the performance of a 
> > file system while doing many meta-data operations or throughput testing 
> > during heavy journal log activity.
> 
> Back in 2005, Alex sent a patch to monitor journal activity through procfs:
> http://marc.info/?l=linux-ext4&m=113538565128617&w=2
> 
> We have been using this patch for more than 1 year and it is very useful
> for investigating performance issues.
> Does anybody know why this patch hasn't found its way into the mainline?
> Maybe it could be merged in jbd2?

Yes, we use this functionality failry often, so having it in jbd2 would
be quite useful.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
