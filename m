From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xattr index for hurd
Date: Sun, 31 Jul 2016 23:04:53 -0700
Message-ID: <20160801060453.GA32095@infradead.org>
References: <a3ef36c5-cd3b-5fc2-e9fc-eb7e823f0510@outlook.com>
 <BLU175-W270CF93954CBCB94CA36CC9360@phx.gbl>
 <20160801034228.GE12853@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LastAvengers <lastavengers@outlook.com>, Jan Kara <jack@suse.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbcHAGE5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2016 02:04:57 -0400
Content-Disposition: inline
In-Reply-To: <20160801034228.GE12853@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note thast _iff_ you ever want to expose the hurd xattrs under Linux
(or in fact at all - gnu.* is only fine for purely internal usage)
please use the system namespace.  We really shouldn't expose more than
the existing namespaces to userspace.
