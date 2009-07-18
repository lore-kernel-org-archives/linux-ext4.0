From: Stephan Kulow <coolo@suse.de>
Subject: Re: file allocation problem
Date: Sat, 18 Jul 2009 23:16:39 +0200
Message-ID: <200907182316.39516.coolo@suse.de>
References: <200907161331.17623.coolo@suse.de> <200907172002.19286.coolo@suse.de> <20090717211444.GF4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:39891 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbZGRVQn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jul 2009 17:16:43 -0400
In-Reply-To: <20090717211444.GF4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 17 July 2009 23:14:44 Andreas Dilger wrote:
> > Yeah, but even the file in /tmp/nd got 3 extents. my file is 1142 blocks
> > and my mb_groups says 2**9 is the highest possible value. So I guess I
> > will indeed try to create the file system from scratch to test the
> > allocator for real.
>
> The defrag code needs to become smarter, so that it finds small files
> in the middle of freespace and migrates those to fit into a small gap.
> That will allow larger files to be defragged once there is large chunks
> of free space.

Is there a way that user space can hint the allocator to fill these gaps? I 
don't see any obvious way. Relying on the allocator not to make matters worse
might be enough, but it doesn't sound ideal. Unless something urgent comes up
I might actually continue experiment next week :)

My resize2fs defrag worked pretty well actually, but then again I did it on an 
offline copy and it won't work for online that way.

Greetings, Stephan
