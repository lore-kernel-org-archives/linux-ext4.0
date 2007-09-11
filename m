From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] FLEX_BG Kernel support.
Date: Tue, 11 Sep 2007 07:27:17 -0500
Message-ID: <20070911072717.1b5fc7a8@gara>
References: <20070910212224.13310.54532.stgit@toolssf2>
	<2aa04ba80709102304i1b054fbbo1d0d4081a86c1580@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "ext4 development" <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:43113 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbXIKM1O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Sep 2007 08:27:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8BCRDBL010707
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 08:27:13 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8BCRDc9425692
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 06:27:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8BCRDNx021827
	for <linux-ext4@vger.kernel.org>; Tue, 11 Sep 2007 06:27:13 -0600
In-Reply-To: <2aa04ba80709102304i1b054fbbo1d0d4081a86c1580@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 11 Sep 2007 00:04:43 -0600
"Andreas Dilger" <adilger@clusterfs.com> wrote:

> On 9/10/07, Jose R. Santos <jrs@us.ibm.com> wrote:
> > @@ -1254,7 +1254,8 @@ static int ext4_check_descriptors (struct super_block * sb)
> >
> >         for (i = 0; i < sbi->s_groups_count; i++)
> >         {
> > -               if (i == sbi->s_groups_count - 1)
> > +               if (i == sbi->s_groups_count - 1 || EXT4_HAS_INCOMPAT_FEATURE(sb,
> > +                                       EXT4_FEATURE_INCOMPAT_FLEX_BG))
> >                         last_block = ext4_blocks_count(sbi->s_es) - 1;
> 
> No need to check this featyre for every  group, once at the beginning
> of the function is enough.
> 

Do you mean something like the original patch?
http://lists.openwall.net/linux-ext4/2007/07/12/20

Wouldn't we need to check all the descriptor for corruption if checksum
is not enable on the filesystem?

-JRS
