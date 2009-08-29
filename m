From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Allow rename even if link count is greater than
	EXT4_LINK_MAX for index directories
Date: Fri, 28 Aug 2009 21:51:28 -0400
Message-ID: <20090829015128.GJ16732@mit.edu>
References: <1251286645-14439-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZH2Bvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 21:51:35 -0400
Content-Disposition: inline
In-Reply-To: <1251286645-14439-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 05:07:25PM +0530, Aneesh Kumar K.V wrote:
> With EXT4_FEATURE_RO_COMPAT_DIR_NLINK we enable more than EXT4_LINK_MAX
> sub directories. So we should not fail rename with too many links error
> if EXT4_FEATURE_RO_COMPAT_DIR_NLINK feature is set.

Thanks, added to the ext4 patch queue.

						- Ted
