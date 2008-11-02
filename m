From: Graham Murray <graham@gmurray.org.uk>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 02 Nov 2008 21:54:23 +0000
Message-ID: <87fxm9bxps.fsf@newton.gmurray.org.uk>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu>
	<490E1FB1.8020100@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newton.gmurray.org.uk ([81.2.114.237]:58325 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbYKBWNx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 17:13:53 -0500
Received: from newton.gmurray.org.uk (graham@localhost [127.0.0.1])
	by newton.gmurray.org.uk (8.14.3/8.14.3) with ESMTP id mA2LsN9C013996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 2 Nov 2008 21:54:24 GMT
In-Reply-To: <490E1FB1.8020100@tvcablenet.be> (news gmane org's message of
	"Sun, 02 Nov 2008 22:46:25 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"news.gmane.org" <francois.valenduc@tvcablenet.be> writes:

> In fact, the errors I mentionned don't occur anymore. But the problem of
>   the diskspace remains. I never managed until now to use more than one
> third of a partition on a 32 bit system. After that, I always get a
> message saying that the partition is full, which can't be true.

Just an idea, which I am sure you have already considered, but have you
run out of inodes? 
