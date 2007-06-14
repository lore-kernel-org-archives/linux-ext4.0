From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH 4/6] add noversion mount option
Date: Fri, 15 Jun 2007 03:22:06 +0530
Message-ID: <1181857932.3926.4.camel@garfield>
References: <1181835073.7779.9.camel@garfield>
	 <1181836579.7779.46.camel@garfield>
	 <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59289 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXFNVxV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 17:53:21 -0400
In-Reply-To: <1181854214.3883.10.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-14 at 13:50 -0700, Mingming Cao wrote:
> On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
> > This patch adds a "noversion" mount option to disable inode version
> > updates.
> 
> Can you explain a bit more why we need this mount option? Is it because
> of performance concern? 

Lustre requires the counter to be globally unique on the entire
filesystem and hence needs to turnoff per-inode version updates. So in
the interlock meeting on 5th June, Ted has suggested the this approach.

"- Ted suggested having a flag in the superblock for i_version, with an 
additional option of having a global counter for Lustre's requirements.
i_version would be on by default, but give users who do not use the 
feature the option to turn it off and avoid any performance impact."

Thanks,
Kalpak.

> 
> Mingming
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
