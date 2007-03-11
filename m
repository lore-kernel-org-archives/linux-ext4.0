From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: Ext4 devel interlock meeting minutes (March 7, 2007)
Date: Sun, 11 Mar 2007 14:25:41 +0530
Message-ID: <cc723f590703110055m38e1f347scde9b16b8ff9fad7@mail.gmail.com>
References: <45F05099.5020506@linux.vnet.ibm.com>
	 <20070308230326.GI5823@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Avantika Mathur" <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Andreas Dilger" <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:7726 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbXCKIzp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2007 04:55:45 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1852614uga
        for <linux-ext4@vger.kernel.org>; Sun, 11 Mar 2007 00:55:41 -0800 (PST)
In-Reply-To: <20070308230326.GI5823@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/9/07, Andreas Dilger <adilger@clusterfs.com> wrote:
> On Mar 08, 2007  10:06 -0800, Avantika Mathur wrote:
> >
>
> > - Aneesh Veetil has been working on a migration tool from block based to
> > extents allocation. He is looking at two options.
> >
> >    - Offline Migration: Modify e2fsprogs code to actually be able to create
> >    extents. This involves a lot of duplication of ext4 code (btree).
> >    e2fsprogs has code for interpreting extents, but code for creating them
> >    would have to be duplicated.
> >
> >    - Online Migration: Use existing filesystem code to convert to extents -
> >    similar to online defragmentation.
>
> I would prefer to implement this using the same code as the online defrag.
> To be useful, the online defrag has to work with block-mapped files anyways.

Is there a tree (git or hg ) which i can use to get a working online defrag ?

-aneesh
