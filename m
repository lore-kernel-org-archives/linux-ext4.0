From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Sun, 14 Oct 2007 21:51:15 -0400
Message-ID: <20071015015114.GG9715@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488221.15770.46.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43551 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbXJOBvl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 21:51:41 -0400
Content-Disposition: inline
In-Reply-To: <1188488221.15770.46.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2007 at 05:37:01PM +0200, Valerie Clement wrote:
> 
> From: Valerie Clement <valerie.clement@bull.net>
> 
> This patch adds a new option -D <descriptor-size> to mkfs to allow creating
> ext4 filesystems with larger group descriptor size.

The patch is missing a man page update. 

In addition, the descriptor size is something that should be
configurable via mke2fs.conf, via the [defaults] and [fs_types]
stanza.  (And don't forget to update the mke2fs.conf man page.)

	      	    	      	     - Ted
