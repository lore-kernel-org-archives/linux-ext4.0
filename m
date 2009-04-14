From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext4: really print the find_group_flex fallback
	warning only once
Date: Tue, 14 Apr 2009 07:30:26 -0400
Message-ID: <20090414113026.GD955@mit.edu>
References: <20090413190330.754a0dec@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44506 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDNLad (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Apr 2009 07:30:33 -0400
Content-Disposition: inline
In-Reply-To: <20090413190330.754a0dec@dhcp-100-2-144.bos.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 13, 2009 at 07:03:29PM -0400, Chuck Ebbert wrote:
> ext4: really print the find_group_flex fallback warning only once
> 
> Missing braces caused the warning to print more than once.

Thanks, applied.

					- Ted
