From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery
	loop into separate functions
Date: Sat, 8 Mar 2008 09:53:51 -0500
Message-ID: <20080308145351.GB18522@infradead.org>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYCHOxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 09:53:52 -0500
Content-Disposition: inline
In-Reply-To: <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2008 at 01:59:12AM +0000, Duane Griffin wrote:
> +static int replay_data_block(
> +	journal_t *journal, struct buffer_head *obh, char *data,
> +	int flags, unsigned long blocknr)

quite odd formatting, this should be more like:

static int replay_data_block(journal_t *journal, struct buffer_head *obh,
		char *data, int flags, unsigned long blocknr)

(same for the other new helpers)

