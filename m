From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 16:30:06 -0400
Message-ID: <20130513203006.GA20102@thunk.org>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
 <20130513131809.GG400@quack.suse.cz>
 <20130513133036.GB4845@thunk.org>
 <87bo8fxa92.fsf@openvz.org>
 <20130513135221.GE4845@thunk.org>
 <878v3jx9oi.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, EUNBONG SONG <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48126 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3EMUaR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 16:30:17 -0400
Content-Disposition: inline
In-Reply-To: <878v3jx9oi.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 13, 2013 at 05:59:25PM +0400, Dmitry Monakhov wrote:
> > This is how it's failing for me....
> Because you ask questions, but do not read answers :)
> http://marc.info/?l=linux-ext4&m=136580060822252&w=2
> http://marc.info/?l=linux-ext4&m=136610044500931&w=2

Sorry, I thought I was running with the updated fio, but apparently I
was using an old xfstests.tar.gz tarball on my KVM image.  Mea culpa....

    	     	 		 	 - Ted
