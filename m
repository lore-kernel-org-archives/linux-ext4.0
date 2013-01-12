From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: add debug switch to use old online interface
Date: Fri, 11 Jan 2013 19:30:27 -0500
Message-ID: <20130112003027.GA9550@thunk.org>
References: <50F05175.8060502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42857 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3ALAbo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 19:31:44 -0500
Content-Disposition: inline
In-Reply-To: <50F05175.8060502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 11:52:53AM -0600, Eric Sandeen wrote:
> --- a/resize/resize2fs.h
> +++ b/resize/resize2fs.h
> @@ -76,6 +76,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
>  #define RESIZE_DEBUG_BMOVE		0x0002
>  #define RESIZE_DEBUG_INODEMAP		0x0004
>  #define RESIZE_DEBUG_ITABLEMOVE		0x0008
> +/* old online resize interface */
> +#define RESIZE_DEBUG_OLD		0x0010

0x0010 is already used for

#define RESIZE_DEBUG_RTRACK		0x0010

(which is very useful for performance tuning resize2fs).

I wonder if we would be better off using a environment variable for
this?  Mainly because currently, the current resize flags don't
actually change the behavior of resize2fs, but just add different
levels of debugging messages. 

						- Ted
