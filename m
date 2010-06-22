From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 0/8] Cleancache: overview
Date: Tue, 22 Jun 2010 02:40:19 -0400
Message-ID: <20100622064019.GA22099@infradead.org>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
	jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
	npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com,
	avi@redhat.com, konrad.wilk@oracle.com
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0FVGka (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 02:40:30 -0400
Content-Disposition: inline
In-Reply-To: <20100621231809.GA11111@ca-server1.us.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

What all this fails to explain is that this actually is useful for?

Your series adds lots of crappy code, entiely stupid interactions with a
handfull filesystems, but no actual users.

