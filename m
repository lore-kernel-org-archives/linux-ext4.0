From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] Adding support to freeze and unfreeze a journal
Date: Mon, 9 May 2011 11:53:13 +0200
Message-ID: <20110509095313.GB4122@quack.suse.cz>
References: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca>
 <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, jack@suse.cz,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1EIJxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 05:53:16 -0400
Content-Disposition: inline
In-Reply-To: <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 07-05-11 23:04:22, Surbhi Palande wrote:
> +void jbd2_journal_thaw(journal_t * journal)
> +{
> +	write_lock(&journal->j_state_lock);
> +	journal->j_flags = journal->j_flags &= ~JBD2_FROZEN;
> +	write_unlock(&journal->j_state_lock);
> +	smp_wmb();
  Why is here the smp_wmb()? The write is inside a rw-lock so it cannot be
reordered. Also wake_up() is protected by queue->lock so I don't see the
need for a barrier.

> +	wake_up(&journal->j_wait_frozen);
> +}
> +EXPORT_SYMBOL(jbd2_journal_thaw);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
