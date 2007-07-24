From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: New e2fsprog doc on the ext4 wiki page.
Date: Tue, 24 Jul 2007 10:34:53 -0600
Message-ID: <20070724163453.GI5992@schatzie.adilger.int>
References: <20070724110741.65ade06e@rx8> <46A62672.70808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:37173 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXGXQe4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 12:34:56 -0400
Content-Disposition: inline
In-Reply-To: <46A62672.70808@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 24, 2007  21:48 +0530, Aneesh Kumar K.V wrote:
> Jose R. Santos wrote:
> >ext4migrate:
> >- Patches submited to the mailing list by Aneesh Kumar
> >http://thread.gmane.org/gmane.comp.file-systems.ext4/1395
> 
> I guess what we are looking at here is 
> 
> a) ext3 -> ext4 conversion would be done via option for defrag. This
> conversion is now done via a ioctl. This is the suggested method for
> defragmenting an ext3 inode (convert to ext4 and then defrag). 
> 
> b) small inode to large inode conversion is done via tune2fs -I < 
> new_inode_size>
>   I have patches for this ready. Will be sending them in a day or two.
> 
> So the ext4migrate command may not be really needed.

Ah, excellent news.  Having a single tool (tune2fs) to manage configuration
changes is much nicer.  Having the generic undo manager to handle these
kind of changes will allow us to do all kind of changes in the future.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
