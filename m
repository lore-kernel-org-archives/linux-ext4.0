From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 V2] ext4: remove the resize mount option
Date: Mon, 7 Nov 2011 10:56:03 -0500
Message-ID: <20111107155603.GD24234@thunk.org>
References: <4EB17085.9060107@redhat.com>
 <4EB1717B.1000202@redhat.com>
 <4EB171AA.2040006@redhat.com>
 <10B11A15-3B01-485E-9818-0ED5578170E2@dilger.ca>
 <4EB182D3.5000300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49067 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1KGP4E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 10:56:04 -0500
Content-Disposition: inline
In-Reply-To: <4EB182D3.5000300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 02, 2011 at 12:50:11PM -0500, Eric Sandeen wrote:
> 
> Hm.  Well, just because it -can- be done ... should it be done?
> We could do all sorts of things via mount options if we really
> wanted to.  mount -o tune2fs=^journal, you name it.

I tend to side with Eric that it seems to be an unnecessary
complication.  At the very least, if we were going to keep it, there
would have to be an xfstests for it, since I'm fairly certain
"mount -o resize=NNN" would be rarely, if ever, tested.

       	  	      	       	       	  - Ted
