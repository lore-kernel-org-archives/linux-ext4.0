From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 v5] XFS TESTS: Expand 252 punch hole test
Date: Mon, 20 Jun 2011 05:07:54 -0400
Message-ID: <20110620090754.GA27583@infradead.org>
References: <4DED63DE.1070000@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43629
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab1FTJH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 05:07:58 -0400
Content-Disposition: inline
In-Reply-To: <4DED63DE.1070000@vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This actually broke 242 due to the new output from the new tests for me.

Next time please do a full xfsqa run before submitting patches.

