From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] * request_tbl.c (ss_add_request_table): Avoid leak
	upon failed realloc.
Date: Sun, 8 Mar 2009 20:40:39 -0400
Message-ID: <20090309004039.GC9903@mit.edu>
References: <87ocwtcbf6.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44160 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZCIDPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Mar 2009 23:15:43 -0400
Content-Disposition: inline
In-Reply-To: <87ocwtcbf6.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

						- Ted
