From: Andreas Dilger <adilger@sun.com>
Subject: Re: Entries in feature_list[]
Date: Sat, 12 Apr 2008 21:49:57 -0600
Message-ID: <20080413034957.GA8058@webber.adilger.int>
References: <1206603634.3379.4.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Girish Shilamkar <Girish.Shilamkar@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62421 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbYDMDuG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Apr 2008 23:50:06 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3D3o5wv016077
	for <linux-ext4@vger.kernel.org>; Sat, 12 Apr 2008 20:50:05 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZ800M01VX2O800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 12 Apr 2008 20:50:05 -0700 (PDT)
In-reply-to: <1206603634.3379.4.camel@alpha.linsyssoft.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 27, 2008  13:10 +0530, Girish Shilamkar wrote:
> In e2fsprogs/lib/e2p/feature.c 
> struct feature feature_list[] contains:
>         ... 
> 	{       E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
>                         "extents" },
>         {       E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_META_BG,
>                         "meta_bg" }
>         {       E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS,
>                         "extent" },
>         ...
> 
> Is the { E2P_*, EXT3_*, "extent"} entry correct one, if yes, what is the purpose behind having two
> {E2P_FEATURE_INCOMPAT, EXT3_FEATURE_INCOMPAT_EXTENTS, *} entries, unless we want "extent" to be 
> correct feature ?

This is probably a merge error, or maybe a convenice measure to allow both
"extent" and "extents"?  We need something similar for "uninit_groups"
and the new "uninit_bg".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

