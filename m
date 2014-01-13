From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] Add support for new compat feature "one_backup_sb"
Date: Mon, 13 Jan 2014 11:19:49 -0500
Message-ID: <20140113161949.GB22541@thunk.org>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu>
 <20140113132707.GA22358@orion.maiolino.org>
 <20140113140645.GC18029@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48016 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaAMQT5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 11:19:57 -0500
Content-Disposition: inline
In-Reply-To: <20140113140645.GC18029@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 09:06:45AM -0500, Theodore Ts'o wrote:
> I'm just not entirely sure it's worth the extra hair, either way.  I'm
> curious to hear what other people think.

After the ext4 concall this morning, I've been convinced by Carlos's
and Andreas' arguments that we should add a superblock at the end of
the disk.  So I'll rework the patches to do that.

	    	      	   	      	      - Ted



