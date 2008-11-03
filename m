From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 17:47:55 -0500
Message-ID: <20081103224755.GG18117@mit.edu>
References: <4908C951.2000309@redhat.com> <20081103184426.GA31894@ajones-laptop.nbttech.com> <20081103113318.35b0c266.akpm@linux-foundation.org> <20081103201428.GB30565@ajones-laptop.nbttech.com> <20081103123750.67c96224.akpm@linux-foundation.org> <20081103214840.GA3371@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44059 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752509AbYKCWsL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 17:48:11 -0500
Content-Disposition: inline
In-Reply-To: <20081103214840.GA3371@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 01:48:40PM -0800, Arthur Jones wrote:
> > - should we clear s_dirt if log_wait_commit() didn't work?
> > 
> > - ext3_force_commit() clears s_dirt also
> 
> I'm not sure if it makes sense, but ATM I don't think it
> hurts anything given that ext3_write_super is just sb->s_dirt = 0;

I want to look at this some more, but it's possible we should just
remove all of the references to sb->s_dirt completely.  Also, the
comment just above ext[34]_write_super() is out of date since before
2.6.0.

						- Ted
