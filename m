From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Thu, 7 Mar 2013 19:46:20 -0500
Message-ID: <20130308004620.GB29720@thunk.org>
References: <20130305121856.GA11824@quack.suse.cz>
 <20130305182946.GB26122@thunk.org>
 <20130305184138.GA19601@quack.suse.cz>
 <20130307182444.GA21237@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51892 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228Ab3CHAqX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 19:46:23 -0500
Content-Disposition: inline
In-Reply-To: <20130307182444.GA21237@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

By the way, why was the application trying to access the directory
entries directly, as opposed to using some of the higher level
functions in libext2fs?  What was it trying to do?

Is there some new higher-level functionality we should be providing?
Or was this just an application that didn't know about some better
interface that it could have used?  Is this an open source
application?  Can you send me a pointer to it?

	     		      	     - Ted
