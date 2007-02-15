From: Theodore Tso <tytso@mit.edu>
Subject: Re: i_version_2_ext4_specific_code
Date: Thu, 15 Feb 2007 12:30:15 -0500
Message-ID: <20070215173015.GD5285@thunk.org>
References: <20070215002218.56944d89.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean Noel Cordenner <jean-noel.cordenner@bull.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46426 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030321AbXBORaX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 12:30:23 -0500
Content-Disposition: inline
In-Reply-To: <20070215002218.56944d89.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 15, 2007 at 12:22:18AM -0800, Andrew Morton wrote:
> 
> This:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.20-ext4-1/broken-out/i_version_2_ext4_specific_code
> 
> has 100% broken whitespace: it uses spaces where there should be hard tabs.
> 
> Please let's not merge anything which does that.

Looking at this patch more closely, it looks like the whitespace was
damaged by a broken mailer.  My apologies, I should have rejected the
patch.

Jean Noel, if you could resend the patch and make sure that your
mailer isn't screwing up whitespace?  If necessary just attach it as a
text file instead of including it inline.

							- Ted


					
