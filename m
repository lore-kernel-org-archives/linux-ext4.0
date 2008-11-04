From: Leroy van Logchem <leroy.vanlogchem@gmail.com>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Tue, 4 Nov 2008 22:15:35 +0000 (UTC)
Message-ID: <loom.20081104T221319-284@post.gmane.org>
References: <20081104161024.GC28058@unused.rdu.redhat.com> <20081104205223.GW30291@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54622 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYKDWUH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2008 17:20:07 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KxUFn-0005W2-8f
	for linux-ext4@vger.kernel.org; Tue, 04 Nov 2008 22:20:03 +0000
Received: from 212-123-148-116.ip.telfort.nl ([212.123.148.116])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 04 Nov 2008 22:20:03 +0000
Received: from leroy.vanlogchem by 212-123-148-116.ip.telfort.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 04 Nov 2008 22:20:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> > +	 * can do, instead of having a static sleep time.  This is usefull for
> 
> s/usefull/useful/

and:

+	 * join the transaction.  We acheive this by measuring how long it takes

s/acheive/achieve/

-- 
Leroy


