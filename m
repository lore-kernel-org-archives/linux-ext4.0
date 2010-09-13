From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Don't bump up LLONG_MAX nr_to_write by a factor of 8
Date: Mon, 13 Sep 2010 17:25:01 -0400
Message-ID: <20100913212501.GD5827@thunk.org>
References: <4C892F89.90201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56335 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0IMVZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Sep 2010 17:25:03 -0400
Content-Disposition: inline
In-Reply-To: <4C892F89.90201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 09, 2010 at 02:03:37PM -0500, Eric Sandeen wrote:
> I'm uneasy with lots of stuff going on in ext4_da_writepages(),
> but bumping nr_to_write from LLONG_MAX to -8 clearly isn't
> making anything better, so avoid the multiplier in that case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 tree, thanks.

						- Ted
