From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 23:35:06 +0800
Message-ID: <20130327153506.GA4565@gmail.com>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
 <20130327135155.GK5861@thunk.org>
 <20130327150735.GA4395@gmail.com>
 <20130327151922.GA4487@gmail.com>
 <20130327151248.GE14900@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:46464 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3C0PTW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 11:19:22 -0400
Received: by mail-da0-f43.google.com with SMTP id u36so4163238dak.30
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 08:19:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327151248.GE14900@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:12:48AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 11:19:22PM +0800, Zheng Liu wrote:
> > > > Otherwise, couldn't we end up with problems where a failed write calls
> > > > ext4_truncate() without i_data_sem(), and that races with something
> > > > else --- say, a punch or truncate call to that same inode?
> > 
> > Let me think about it.  I need to take a close look at it.
> 
> Note that I'm not so concerned when we are creating symlink --- you
> are quite right in pointing out in that case the inode isn't in the
> namespace yet, so that prevents races --- but also what might happen
> in an ENOSPC write(2) failure racing against a punch/truncate call.
> 
> But again, this is why I added the warning --- it was to find these
> edge cases that we might not have considered.  :-)

ext4_truncate_failed_write() is called by the following functions:
 - ext4_ind_direct_IO
 - ext4_convert_inline_data_to_extent
 - ext4_da_convert_inline_data_to_extent
 - ext4_write_begin
 - ext4_write_end
 - ext4_journalled_write_end
 - ext4_da_write_begin

All these functions are protected by i_mutex.  So we can serialize it
with truncate/punch hole.

Regards,
                                                - Zheng
