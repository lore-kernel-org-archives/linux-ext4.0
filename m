From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: hook fiemap operation for directories
Date: Sat, 2 May 2009 19:06:58 -0400
Message-ID: <20090502230658.GB12368@mit.edu>
References: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1239806343-14219-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39823 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZEBXHC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 19:07:02 -0400
Content-Disposition: inline
In-Reply-To: <1239806343-14219-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2009 at 08:09:03PM +0530, Aneesh Kumar K.V wrote:
> Add fiemap callback for directories
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks, I've pulled this into the ext4 patch queue.

						- Ted
