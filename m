From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Sat, 5 Aug 2017 01:46:01 -0700
Message-ID: <20170805084601.GA12425@infradead.org>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdHEIqB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Aug 2017 04:46:01 -0400
Content-Disposition: inline
In-Reply-To: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please don't do this until we have a coherent DAX plan.  So far
the flag in XFS seems like a massive mistake and we need to get
rid of it instead of adding it to more file systems.
