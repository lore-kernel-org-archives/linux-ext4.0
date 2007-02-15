From: Theodore Tso <tytso@mit.edu>
Subject: Re: i_version_3_ext4_user_interface.patch
Date: Thu, 15 Feb 2007 12:35:20 -0500
Message-ID: <20070215173520.GE5285@thunk.org>
References: <20070215040021.63bde922.akpm@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean Noel Cordenner <jean-noel.cordenner@bull.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40890 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148AbXBORf2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 12:35:28 -0500
Content-Disposition: inline
In-Reply-To: <20070215040021.63bde922.akpm@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 15, 2007 at 04:00:21AM -0800, Andrew Morton wrote:
> 
> ia64 allmodconfig gives:
> 
> fs/stat.c: In function `cp_new_stat':
> fs/stat.c:234: error: structure has no member named `st_i_version'
> 
> I'll drop the ext4 tree.

Looks like the problem is that the patch hacks include/asm-i386/stat.h
and include/asm-x86_64, but no other architecture.  

Jean Noel, I'm going to drop NFSv4 i_version patches from the ext4 tree
until all of these issues have been dealt with.

					- Ted
