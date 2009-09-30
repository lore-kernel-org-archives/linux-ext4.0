From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: enable generic filesystems on some ENOSPC
	tests
Date: Wed, 30 Sep 2009 08:43:55 -0400
Message-ID: <20090930124355.GB7463@infradead.org>
References: <4AC1114C.2070802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZI3Mnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 08:43:52 -0400
Content-Disposition: inline
In-Reply-To: <4AC1114C.2070802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The change to 204 and the infrastructure seems fine for me, but I don't
really like how the other use an explicit agcount (which at least for
109 was very intentional) for xfs and just defaults for others.  At
least 109 should be duplicated into a generic one run everywhere and
an xfs-specific with the agcount.  Need to look a bit more at the
history of 083 to max a decision for that one.  And some less cryptic
variable names in the new code would also be nice.

