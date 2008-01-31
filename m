From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Re: Fw: [Bugme-new] [Bug 9849] New: NULL pointer deref in
	journal_wait_on_commit_record
Date: Thu, 31 Jan 2008 12:15:30 +0100
Message-ID: <20080131111530.GA4377@alice>
References: <20080130120055.7dc3331b.akpm@linux-foundation.org> <1201735077.3873.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Girish Shilamkar <girish@clusterfs.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758631AbYAaLPf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2008 06:15:35 -0500
Content-Disposition: inline
In-Reply-To: <1201735077.3873.22.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Mingming Cao (cmm@us.ibm.com) wrote:
> We need to check the error returns from journal_submit_commit_record()
> and avoid calling journal_wait_on_commit_record() in the failure case.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

thanks, the patch works for me, i closed the bugzilla entry
