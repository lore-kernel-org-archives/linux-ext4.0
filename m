From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6 v4] Lazy itable initialization for Ext4
Date: Mon, 4 Oct 2010 03:31:17 -0400
Message-ID: <20101004073117.GB2889@thunk.org>
References: <1284641251-24531-1-git-send-email-lczerner@redhat.com>
 <20100928040142.GA7865@thunk.org>
 <alpine.LFD.2.00.1009291516270.2982@dhcp-lab-213.englab.brq.redhat.com>
 <alpine.LFD.2.00.1010011752280.2854@dhcp-lab-213.englab.brq.redhat.com>
 <20101002195535.GM21129@thunk.org>
 <20101003024329.GO21129@thunk.org>
 <20101004023649.GA2889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca, snitzer@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55844 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0JDHbV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Oct 2010 03:31:21 -0400
Content-Disposition: inline
In-Reply-To: <20101004023649.GA2889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 03, 2010 at 10:36:49PM -0400, Ted Ts'o wrote:
> +
> +		if (jiffies >= next_wakeup) {
> +			cond_resched();
> +			continue;
> +		}

This should be a time_after_eq(jiffies, next_wakeup), of course...

					- Ted

