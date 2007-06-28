From: Nathan Scott <nscott@aconex.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Thu, 28 Jun 2007 10:53:08 +1000
Message-ID: <1182991988.15488.95.camel@edge.yarra.acx>
References: <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070625134500.GE1951@amitarora.in.ibm.com>
	 <20070625150320.GA8686@amitarora.in.ibm.com>
	 <20070625214626.GJ5181@schatzie.adilger.int>
	 <20070626231431.GO31489@sgi.com>
	 <20070627034915.GR6652@schatzie.adilger.int>
	 <20070627133657.GQ989688@sgi.com>
	 <1182986916.15488.88.camel@edge.yarra.acx>
	 <20070628003921.GW989688@sgi.com>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, xfs-oss <xfs@oss.sgi.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, cmm@us.ibm.com
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.app.aconex.com ([203.89.192.138]:45897 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbXF1AyM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jun 2007 20:54:12 -0400
In-Reply-To: <20070628003921.GW989688@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-28 at 10:39 +1000, David Chinner wrote:
> 
> 
> I don't think it does - swapfile I/O looks like it goes direct to
> bio without passing through the filesystem.  When the swapfile is
> mapped, it scans and records the extent map of the entire swapfile
> in a separate structure and AFAICT the swap code uses that built map
> without touching the filesystem at all.
> 
> If that is true then the written/unwritten state of the extents is
> irrelevant; all we need is allocated disk space for the file and
> swapping should work. And it's not like anyone should be reading
> the contents of that swapfile through the filesystem, either. ;)

Ah, yes, good point - thats true.  Unwritten extents are ideal for
this then, as attempts to read swap via the regular interfaces will
return zeros instead of random swapped out memory contents.

cheers.
