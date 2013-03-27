From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 11:12:48 -0400
Message-ID: <20130327151248.GE14900@thunk.org>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
 <20130327135155.GK5861@thunk.org>
 <20130327150735.GA4395@gmail.com>
 <20130327151922.GA4487@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56404 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3C0PMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 11:12:49 -0400
Content-Disposition: inline
In-Reply-To: <20130327151922.GA4487@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:19:22PM +0800, Zheng Liu wrote:
> > > Otherwise, couldn't we end up with problems where a failed write calls
> > > ext4_truncate() without i_data_sem(), and that races with something
> > > else --- say, a punch or truncate call to that same inode?
> 
> Let me think about it.  I need to take a close look at it.

Note that I'm not so concerned when we are creating symlink --- you
are quite right in pointing out in that case the inode isn't in the
namespace yet, so that prevents races --- but also what might happen
in an ENOSPC write(2) failure racing against a punch/truncate call.

But again, this is why I added the warning --- it was to find these
edge cases that we might not have considered.  :-)

     	   	   	     	  	       - Ted
