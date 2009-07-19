From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: file allocation problem
Date: Sun, 19 Jul 2009 17:45:05 -0500
Message-ID: <4A63A1F1.9040703@cox.net>
References: <200907161331.17623.coolo@suse.de> <200907170717.12225.coolo@suse.de> <20090717142628.GL8508@mit.edu> <200907172002.19286.coolo@suse.de> <20090717211444.GF4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao107.cox.net ([68.230.240.59]:34861 "EHLO
	eastrmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZGSWpL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 18:45:11 -0400
Received: from eastrmimpo01.cox.net ([68.1.16.119])
          by eastrmmtao107.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090719224506.GEWV4885.eastrmmtao107.cox.net@eastrmimpo01.cox.net>
          for <linux-ext4@vger.kernel.org>; Sun, 19 Jul 2009 18:45:06 -0400
In-Reply-To: <20090717211444.GF4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-07-17 16:14, Andreas Dilger wrote:
[snip]
> 
> Well, this isn't quite correct.  The mballoc code only tries to allocate
> "large" files on power-of-two boundaries, where large is 64kB by default,
> but is tunable in /proc.  For smaller files it tries to pack them together
> into the same block, or into gaps that are exactly the size of the file.

How does ext4 act on growing files?  I.e., creating a tarball that, 
obviously, starts at 0 bytes and then grows to multi-GB?

-- 
Scooty Puff, Sr
The Doom-Bringer
