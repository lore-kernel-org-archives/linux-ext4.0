From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Online defragmentation patches [Was Re: Ext4 devel interlock meeting minutes (March 7, 2007) ]
Date: Sun, 11 Mar 2007 15:37:23 +0530
Message-ID: <cc723f590703110307i78187fecp1406a43c58b7923f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Avantika Mathur" <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Andreas Dilger" <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:19333 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXCKKHZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2007 06:07:25 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1636751muf
        for <linux-ext4@vger.kernel.org>; Sun, 11 Mar 2007 03:07:24 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/11/07, Aneesh Kumar <aneesh.kumar@gmail.com> wrote:
> On 3/9/07, Andreas Dilger <adilger@clusterfs.com> wrote:
> > On Mar 08, 2007  10:06 -0800, Avantika Mathur wrote:
> > >
> >
> > > - Aneesh Veetil has been working on a migration tool from block based to
> > > extents allocation. He is looking at two options.
> > >
> > >    - Offline Migration: Modify e2fsprogs code to actually be able to create
> > >    extents. This involves a lot of duplication of ext4 code (btree).
> > >    e2fsprogs has code for interpreting extents, but code for creating them
> > >    would have to be duplicated.
> > >
> > >    - Online Migration: Use existing filesystem code to convert to extents -
> > >    similar to online defragmentation.
> >
> > I would prefer to implement this using the same code as the online defrag.
> > To be useful, the online defrag has to work with block-mapped files anyways.
>
> Is there a tree (git or hg ) which i can use to get a working online defrag ?
>

This is what i tried.

GIT_DIR=/home/opensource/linux-2.6/.git git archive --format=tar
--prefix=linux-2.6.ext4/  v2.6.19-rc6 | tar -xv

That is 2.6.19-rc6.

now i downloaded the patches at

ftp://ftp.clusterfs.com/pub/people/alex/2.6.19-rc6/ and applied it in
the same order as found in the series. The patch doesn't apply
cleanly.

I have downloaded online patches at
http://article.gmane.org/gmane.comp.file-systems.ext4/1011-1014


-aneesh
