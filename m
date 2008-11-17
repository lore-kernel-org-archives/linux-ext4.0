From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal, take 2.
Date: Mon, 17 Nov 2008 10:11:15 -0800
Message-ID: <1226945475.23804.17.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <1226431111.4444.41.camel@bobble.smo.corp.google.com>
	 <20081117000445.GA3436@webber.adilger.int>
	 <1226942458.23804.10.camel@bobble.smo.corp.google.com>
	 <20081117180801.GC3146@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:56160 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYKQSLV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 13:11:21 -0500
In-Reply-To: <20081117180801.GC3146@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-11-17 at 12:08 -0600, Andreas Dilger wrote:
> On Nov 17, 2008  09:20 -0800, Frank Mayhar wrote:
> > > > +	if (handle->h_transaction == NULL)
> > > > +		return 0;
> > > 
> > > Does this ever happen?  Ah, is this the case where the handle is pointing
> > > to the ext4_sb_info()?  I think I'd prefer to have a magic value here,
> > > so that it isn't possible to accidentally dereference a pointer that
> > > happens to have NULL data in it.
> > 
> > So some magic value that gets stuffed into the pointer?  Or just a magic
> > pointer value that gets stuffed into 'handle'?
> 
> I mean a magic value that is stuffed into the s_nojournal_flag pointer
> instead of just using NULL (which is a very common value of pointers to
> random memory).  Ideally this value will be chosen in a way that it is
> unlikely to be a valid pointer (e.g. 0x01234567 for 32-bit machines,
> 0x0123456789abcdef for 64-bit machines).

Okay, makes sense, will do.

> > > So, this appears to be the place where ext4_sb_info->s_nojournal_flag is
> > > actually used.  To make this more clear, it would be better to do actually
> > > reference this variable here so that it is easier for the reader to follow.
> > > 
> > > 	current->journal_info = &EXT4_SB(sb)->s_nojournal_flag;
> > 
> > Hmm.  Okay, I'll have to think about this a bit; I haven't had my coffee
> > yet.
> 
> This is functionally equivalent to the method you are using (i.e. it stores
> the pointer to the start of the struct), except that it allows the reader
> to find where this field is used.

Yeah, that's what I thought, but like I said, I hadn't had my coffee
yet. :-)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

