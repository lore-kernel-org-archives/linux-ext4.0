From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Thu, 7 Aug 2008 23:28:40 +0300
Message-ID: <20080807202840.GC26307@lh.kyla.fi>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:54564 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYHGUcL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Aug 2008 16:32:11 -0400
Content-Disposition: inline
In-Reply-To: <20080807200717.GB26307@lh.kyla.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 07, 2008 at 11:07:17PM +0300, Sami Liedes wrote:
> On Thu, Aug 07, 2008 at 10:52:51AM -0700, Andrew Morton wrote:
> > Yes, please do test 2.6.26.
> 
> Did that. I can reproduce the same crash on 2.6.26 and 2.6.26.2.

2.6.25.15 crashes too, so I might have been wrong about 2.6.25.4
working (unless something changed between those two versions).

	Sami
