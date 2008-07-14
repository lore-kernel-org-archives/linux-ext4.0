From: Andreas Dilger <adilger@sun.com>
Subject: Re: suspiciously good fsck times?
Date: Mon, 14 Jul 2008 15:19:13 -0600
Message-ID: <20080714211913.GQ6239@webber.adilger.int>
References: <20080710172829.GF10402@mit.edu> <20080710175354.GA3447@mit.edu>
 <48766D71.7050100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44368 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYGNVT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 17:19:27 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6ELJQTB007816
	for <linux-ext4@vger.kernel.org>; Mon, 14 Jul 2008 14:19:26 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4000H01KL96P00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 14 Jul 2008 14:19:26 -0700 (PDT)
In-reply-to: <48766D71.7050100@gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 10, 2008  16:13 -0400, Ric Wheeler wrote:
> It would be interesting to rerun with the 46 million files in one  
> directory as well (basically, for working sets that have no natural  
> mapping into directories like some object based workloads).

I think you'll hit a limit around 15M files in a single directory.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

