From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: Use kstrtoul() instead of parse_strtoul()
Date: Thu, 11 Apr 2013 23:39:32 -0400
Message-ID: <20130412033932.GA23143@thunk.org>
References: <1365513148-23358-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33707 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab3DLDjh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Apr 2013 23:39:37 -0400
Content-Disposition: inline
In-Reply-To: <1365513148-23358-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 03:12:28AM -0000, Lukas Czerner wrote:
> In parse_strtoul() we're still using deprecated simple_strtoul(). Remove
> parse_strtoul() altogether and replace it with kstrtoul()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
