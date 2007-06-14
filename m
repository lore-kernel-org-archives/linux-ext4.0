From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 4/6] add noversion mount option
Date: Thu, 14 Jun 2007 15:28:41 -0700
Message-ID: <1181860122.3883.20.camel@dyn9047017103.beaverton.ibm.com>
References: <1181835073.7779.9.camel@garfield>
	 <1181836579.7779.46.camel@garfield>
	 <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
	 <1181857932.3926.4.camel@garfield>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50682 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXFNW2o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 18:28:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EMSi1a010825
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 18:28:44 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EMShFG204528
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 16:28:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EMShfZ019648
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 16:28:43 -0600
In-Reply-To: <1181857932.3926.4.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-15 at 03:22 +0530, Kalpak Shah wrote:
> On Thu, 2007-06-14 at 13:50 -0700, Mingming Cao wrote:
> > On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> > > This patch adds a "noversion" mount option to disable inode version
> > > updates.
> > 
> > Can you explain a bit more why we need this mount option? Is it because
> > of performance concern? 
> 
> Lustre requires the counter to be globally unique on the entire
> filesystem and hence needs to turnoff per-inode version updates. So in
> the interlock meeting on 5th June, Ted has suggested the this approach.
> 
> "- Ted suggested having a flag in the superblock for i_version, with an 
> additional option of having a global counter for Lustre's requirements.
> i_version would be on by default, but give users who do not use the 
> feature the option to turn it off and avoid any performance impact."
> 
Right. Somehow my impression is that we have agreed to do this through
tune2fs. I was just double checking if the mount option is for the
Lustre use. Anyway, I am fine with a mount option.


> Thanks,
> Kalpak.
> 
> > 
> > Mingming
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
