From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Mon, 21 Jan 2013 15:26:00 -0200
Message-ID: <20733.31272.134910.805714@fisica.ufpr.br>
References: <20730.1955.395545.141779@fisica.ufpr.br>
	<20130121054741.GB321@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adityakali@google.com, jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3AUR0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 12:26:02 -0500
In-Reply-To: <20130121054741.GB321@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o (tytso@mit.edu) wrote on 21 January 2013 00:47:
 >Also, we're still missing repquota functionality for ocfs2 and ext4
 >with the hidden inode feature

It works here with ext4. I haven't removed users yet but current ones
are shown. Both repquota and repquota -v work in the same way as the
vfs one.
