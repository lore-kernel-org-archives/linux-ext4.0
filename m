From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] obsolete config in kernel source (BUFFER_DEBUG)
Date: Mon, 8 Feb 2010 10:58:28 -0800
Message-ID: <20100208105828.1136310a.akpm@linux-foundation.org>
References: <20100205131333.GB6540@faui49.informatik.uni-erlangen.de>
	<20100208135629.GD4321@quack.suse.cz>
	<20100208155031.GK4494@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org, Kazuo Moriwaka <moriwaka@redhat.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Joel Becker <joel.becker@oracle.com>,
	linux-ext4@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab0BHS7n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 13:59:43 -0500
In-Reply-To: <20100208155031.GK4494@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Feb 2010 10:50:31 -0500 tytso@mit.edu wrote:

> I don't have an objection with removing this, but does anyone have the
> latest version of akpm's buffer debugging patches?

My version is datestamped four years ago :( It normally forward-ports
fairly easily.

> I *think* what happened is that akpm forward ported the removed buffer
> debugging patches, or maybe rewrote it from scratch, but for whatever
> reason they never made back into mainline.  Maybe they were too ugly
> to live in mainline, but they have been really handy on occasion.

I think Eric Sandeen might have a fresher version.  Nowadays it should
be done with the tracing infrastructure, I guess.  Although that
infrastructure may not be able to do this - the ext3 debug patch
recorded an LRU array of the below structs within every buffer_head. 
The various BUFFER_TRACE macros would emit a new record into the tail of the
target bh's b[] ring.

struct buffer_history {
	struct buffer_history_item {
		char *function;
		char *info;
		unsigned long b_state;
		unsigned b_list:3;
		unsigned b_jlist:4;
		unsigned pg_dirty:1;
		unsigned cpu:3;
		unsigned b_count:8;
		unsigned long b_blocknr;	/* For src != dest */
#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
		unsigned b_jcount:4;
		unsigned b_jbd:1;
		unsigned b_transaction:1;
		unsigned b_next_transaction:1;
		unsigned b_cp_transaction:1;
		unsigned b_trans_is_running:1;
		unsigned b_trans_is_committing:1;
		void *b_frozen_data;
		void *b_committed_data;
#endif
	} b[BUFFER_HISTORY_SIZE];
	unsigned long b_history_head;	/* Next place to write */
	unsigned long b_history_tail;	/* Oldest valid entry */
};

