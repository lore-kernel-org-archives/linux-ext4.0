From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 60676] New: Stat system call gives permission denied to
 root for links under a sticky bit
Date: Thu, 1 Aug 2013 11:21:16 -0700
Message-ID: <20130801182116.GA32574@infradead.org>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3HASVQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 14:21:16 -0400
Content-Disposition: inline
In-Reply-To: <bug-60676-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try reverting 800179c9b8a1e796e441674776d11cd4c05d61d7

