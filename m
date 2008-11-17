From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Mon, 17 Nov 2008 12:08:01 -0600
Message-ID: <20081117180801.GC3146@webber.adilger.int>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
 <1226431111.4444.41.camel@bobble.smo.corp.google.com>
 <20081117000445.GA3436@webber.adilger.int>
 <1226942458.23804.10.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46038 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYKQSIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 13:08:04 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAHI84fT024847
	for <linux-ext4@vger.kernel.org>; Mon, 17 Nov 2008 10:08:04 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAH00401OQG8H00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 17 Nov 2008 10:08:03 -0800 (PST)
In-reply-to: <1226942458.23804.10.camel@bobble.smo.corp.google.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 17, 2008  09:20 -0800, Frank Mayhar wrote:
> > > +	if (handle->h_transaction == NULL)
> > > +		return 0;
> > 
> > Does this ever happen?  Ah, is this the case where the handle is pointing
> > to the ext4_sb_info()?  I think I'd prefer to have a magic value here,
> > so that it isn't possible to accidentally dereference a pointer that
> > happens to have NULL data in it.
> 
> So some magic value that gets stuffed into the pointer?  Or just a magic
> pointer value that gets stuffed into 'handle'?

I mean a magic value that is stuffed into the s_nojournal_flag pointer
instead of just using NULL (which is a very common value of pointers to
random memory).  Ideally this value will be chosen in a way that it is
unlikely to be a valid pointer (e.g. 0x01234567 for 32-bit machines,
0x0123456789abcdef for 64-bit machines).

> > So, this appears to be the place where ext4_sb_info->s_nojournal_flag is
> > actually used.  To make this more clear, it would be better to do actually
> > reference this variable here so that it is easier for the reader to follow.
> > 
> > 	current->journal_info = &EXT4_SB(sb)->s_nojournal_flag;
> 
> Hmm.  Okay, I'll have to think about this a bit; I haven't had my coffee
> yet.

This is functionally equivalent to the method you are using (i.e. it stores
the pointer to the start of the struct), except that it allows the reader
to find where this field is used.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

