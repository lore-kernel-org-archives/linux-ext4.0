From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: kill i_version support for Hurd-castrated file
 systems
Date: Thu, 20 Mar 2014 01:10:48 -0700
Message-ID: <20140320081048.GA21164@infradead.org>
References: <20140319202009.GA21361@jessie01>
 <1395290051-25682-1-git-send-email-tytso@mit.edu>
 <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"1o5g4r8o@gmail.com" <1o5g4r8o@gmail.com>,
	"738758@bugs.debian.org" <738758@bugs.debian.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaCTIKu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2014 04:10:50 -0400
Content-Disposition: inline
In-Reply-To: <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 19, 2014 at 11:27:57PM -0600, Andreas Dilger wrote:
> Probably worthwhile to make those !EXT4_OS_HURD checks likely()?

Does it make sense to support the format at all given that it's unlikely
to get any testing?

