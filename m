From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Thu, 31 May 2007 02:28:33 +0530
Message-ID: <1180558715.3949.3.camel@garfield>
References: <1179777153.3910.13.camel@garfield>
	 <20070525143957.GA12669@thunk.org>  <1180128981.3916.13.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:40844 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbXE3Uy7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2007 16:54:59 -0400
In-Reply-To: <1180128981.3916.13.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-05-26 at 03:06 +0530, Kalpak Shah wrote:
> Hi Ted,
> 
> On Fri, 2007-05-25 at 10:39 -0400, Theodore Tso wrote:
> > Hi Kalpak,
> > 
> > On Tue, May 22, 2007 at 01:22:32AM +0530, Kalpak Shah wrote:
> > > It will also protect against running e2fsck on a mounted filesystem
> > > by adding similar logic to ext2fs_open().
> > 
> > Your patch didn't add this logic to ext2fs_open(); it just reserved
> > the space in the superblock.
> 
> Yeah the earlier patch for just reserving the fields. 
> 
> > 
> > I don't mind reserving the space so we don't have to worry about
> > conflicting superblock uses, but I'm still on the fence about actually
> > adding this functionality (a) into e2fsprogs, and (b) into the ext4
> > kernel code.  I guess it depends on how complicated/icky the
> > implementation code is, I guess.
> 

Hi Ted,

So can I assume that the INCOMPAT_MMP flag and the s_mmp_interval and
s_mmp_block superblock fields will be reserved regardless of whether the
patches go into ext4? I had attached the patches in the last mail so you
can share your views on them.

Thanks,
Kalpak.
