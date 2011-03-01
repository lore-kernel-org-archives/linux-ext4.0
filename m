From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Tue, 1 Mar 2011 06:07:02 -0500
Message-ID: <20110301110702.GA14336@infradead.org>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
 <20110224063749.GV22723@ZenIV.linux.org.uk>
 <20110224112010.GB23042@quack.suse.cz>
 <4D66BD18.2030207@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1CALHF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 06:07:05 -0500
Content-Disposition: inline
In-Reply-To: <4D66BD18.2030207@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you wire up your testcase with xfstests so we can regression test
for it in the future?

