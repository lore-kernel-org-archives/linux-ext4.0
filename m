From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -v3] ext4: Take page lock before looking at attached
	buffer_heads flags
Date: Wed, 9 Sep 2009 23:25:12 -0400
Message-ID: <20090910032512.GA31907@mit.edu>
References: <20090831063006.GA7711@skywalker.linux.vnet.ibm.com> <1252316684-10646-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZIJDZS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 23:25:18 -0400
Content-Disposition: inline
In-Reply-To: <1252316684-10646-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 07, 2009 at 03:14:44PM +0530, Aneesh Kumar K.V wrote:
> Inorder to check whether the buffer_heads are mapped we need
> to hold page lock. Otherwise a reclaim can cleanup the attached
> buffer_heads.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks, I've added this to the ext4 patch queue, replacing the earlier
-V2 version of this patch.

					- Ted
