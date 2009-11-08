From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 13:12:01 -0500
Message-ID: <20091108181201.GA28075@infradead.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/> <200911062207.nA6M7FgC014166@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZKHSL4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 13:11:56 -0500
Content-Disposition: inline
In-Reply-To: <200911062207.nA6M7FgC014166@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 10:07:15PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> That said, I haven't looked at how nasty it would be to change the name 
> lookup to use <ptr,len>. Maybe it wouldn't be as horrible as I suspect it 
> is (the filesystems themselves wouldn't need changing, since the lowlevel 
> filesystem name lookup routines always sees a 'struct dentry' rather than 
> the pathname).

FYI there are other filesystems that historically store the the name
without terminating NULL in the symlink and would benefit from that.

