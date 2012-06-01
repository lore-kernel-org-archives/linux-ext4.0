From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: let getattr report the right blocks in
 delalloc+bigalloc.
Date: Thu, 31 May 2012 20:43:48 -0400
Message-ID: <20120601004348.GB7897@thunk.org>
References: <1328025496-3521-1-git-send-email-tm@tao.ma>
 <4FC7A5A2.1080704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46868 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab2FAAny (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 20:43:54 -0400
Content-Disposition: inline
In-Reply-To: <4FC7A5A2.1080704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 31, 2012 at 12:08:50PM -0500, Eric Sandeen wrote:
> On 1/31/12 9:58 AM, Tao Ma wrote:
> > From: Tao Ma <boyu.mt@taobao.com>
> > 
> > In delayed allocation, i_reserved_data_blocks now indicates
> > clusters, not blocks. So report it in the right number.
> > 
> > This can be easily exposed by the following command:
> > echo foo > blah; du -hc blah; sync; du -hc blah
> > 
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Reported-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> 
> Reviewed-by: Eric Sandeen <sandeen2redhat.com>
> 
> It'd be great to get this one merged.

I'll merge this, but delalloc and bigalloc is still pretty badly
busted.  But this will make stat return something that is closer to
being correct...

						- Ted
