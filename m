From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 16:48:47 -0700
Message-ID: <20081027164847.46b35a15.akpm@linux-foundation.org>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	<alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: snitzer@gmail.com, linux-ext4@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbYJ0Xsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 19:48:55 -0400
In-Reply-To: <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Oct 2008 19:32:11 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> Attached is a patch that I used for counting.

If we could get something like that into mainline then I can
stop maintaining profile-likely-unlikely-macros.patch, which would
be welcome.
