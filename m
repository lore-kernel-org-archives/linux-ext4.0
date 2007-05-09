From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Creating a >32bit blocks filesystem.
Date: Wed, 9 May 2007 09:15:10 -0700
Message-ID: <20070509161510.GL6375@schatzie.adilger.int>
References: <20070503140804.463b20e1@naruto> <463B4A1B.4070201@bull.net> <20070507111952.7868bc1c@gara> <4641BBB7.8020904@bull.net> <20070509085547.4785bf7d@gara> <4641E13D.906@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54220 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbXEIQoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 12:44:22 -0400
Content-Disposition: inline
In-Reply-To: <4641E13D.906@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  16:57 +0200, Valerie Clement wrote:
> Jose R. Santos wrote:
> >I think this has more to do with the fact that I'm on a 32bit
> >architecture and there are still a couple places where blocks are
> >represented using "unsigned long".  I'm trying to get access to a 64bit
> >arch to confirm this.

> Oh, I didn't catch that you use a 32-bit system.
> On 32-bit architectures, the page cache index size imposes a 16TB limit 
> on the filesystem size (with 4KB blocksize). So you need a 64-bit system 
> for your test.

The mke2fs code should warn the user in this case that the filesystem will
not be usable on 32-bit systems.  I believe mke2fs already checks PAGE_SIZE
in order to validate blocksize > 4096 filesystem requests, and a simple
check for "sizeof(long)" to see if it is a 32-bit system would be enough.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
