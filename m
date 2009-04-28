From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Tue, 28 Apr 2009 20:33:02 +0200
Message-ID: <1240943582.5611.15.camel@marge.simson.net>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757947AbZD1Sd1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 14:33:27 -0400
In-Reply-To: <1240941840.15136.44.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-04-28 at 14:04 -0400, Chris Mason wrote:

> This patch adds the delayed i_size update to ext3, along with a new
> mount option (data=guarded) to enable it.

Is there a good reason to require a new mount option for this vs just
calling it a fix (or enhancement) to the existing writeback option?

I presume yes (you are fs guy..), but wonder what that reason is.

	-Mike

